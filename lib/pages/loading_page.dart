import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 👈 Added Import
import 'result_page.dart';

class LoadingPage extends StatefulWidget {
  final dynamic image;
  final bool useWeather;

  const LoadingPage({
    required this.image,
    required this.useWeather,
    super.key,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
    _analyzeDisease();
  }

  Future<void> _loadImageBytes() async {
    if (kIsWeb) {
      _imageBytes = widget.image as Uint8List;
    } else if (widget.image is File) {
      _imageBytes = await (widget.image as File).readAsBytes();
    } else if (widget.image is Uint8List) {
      _imageBytes = widget.image;
    }
    setState(() {});
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _analyzeDisease() async {
    // ---------------- CONFIGURATION ----------------
    String baseUrl = kReleaseMode
        ? 'http://your-production-server.com'
        : (kIsWeb
        ? 'http://localhost:8000'
        : (Platform.isAndroid
        ? 'http://10.0.2.2:8000'
        : 'http://localhost:8000'));

    final uri = Uri.parse('$baseUrl/analyze_leaf');
    // -----------------------------------------------

    try {
      var request = http.MultipartRequest('POST', uri);

      // 🟢 1. Add User ID (New!)
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        request.fields['user_id'] = userId;
        print("👤 Linked to User ID: $userId");
      }

      // 2. Add Weather/GPS
      request.fields['use_weather'] = widget.useWeather.toString();

      if (widget.useWeather) {
        Position? pos = await _determinePosition();
        if (pos != null) {
          request.fields['lat'] = pos.latitude.toString();
          request.fields['lon'] = pos.longitude.toString();
        }
      }

      // 3. Add Image
      if (widget.image is Uint8List) {
        final bytes = widget.image as Uint8List;
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: 'leaf.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      } else if (widget.image is File) {
        final file = widget.image as File;
        final extension = file.path.split('.').last.toLowerCase();
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            contentType: MediaType(
              'image',
              extension == 'png' ? 'png' : 'jpeg',
            ),
          ),
        );
      }

      // 4. Send
      print("🚀 Sending request...");
      var response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(responseData);
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (_) => ResultPage(image: widget.image, analysisResult: jsonMap),
          ),
        );
      } else {
        print("❌ SERVER ERROR: ${response.statusCode}");
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString().substring(0, 50)}...")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (Keep your existing UI code exactly as it is) ...
    // Just copy the build method from the previous correct version I gave you.
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final double imageSize = isDesktop ? 300 : 200;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyzing..."),
        backgroundColor: const Color(0xFF2E7D32),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: imageSize,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: _imageBytes == null
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : Image.memory(_imageBytes!, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(color: Colors.white),
              const SizedBox(height: 20),
              const Text("Analyzing Leaf...", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart'; // Ensure geolocator is imported
import 'result_page.dart';

class LoadingPage extends StatefulWidget {
  final dynamic image; // File (mobile) or Uint8List (web)
  final bool useWeather; // Toggle from Home Page

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
    // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
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

      // 1. Add Weather/GPS Fields
      request.fields['use_weather'] = widget.useWeather.toString();

      if (widget.useWeather) {
        // Optional: Update UI to show "Getting Location..." here if needed
        Position? pos = await _determinePosition();
        if (pos != null) {
          request.fields['lat'] = pos.latitude.toString();
          request.fields['lon'] = pos.longitude.toString();
          print("📍 GPS Sent: ${pos.latitude}, ${pos.longitude}");
        } else {
          print("⚠️ GPS failed, sending request without coordinates.");
        }
      }

      // 2. Add the Image File (THIS WAS MISSING)
      if (widget.image is Uint8List) {
        // Case A: Image passed as Bytes (Web or after Rotation)
        final bytes = widget.image as Uint8List;
        request.files.add(
          http.MultipartFile.fromBytes(
            'file', // Matches FastAPI parameter 'file'
            bytes,
            filename: 'leaf.jpg', // Required for backend to see it as a file
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      } else if (widget.image is File) {
        // Case B: Image passed as File (Standard Mobile)
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
      } else {
        throw Exception("Unknown image type: ${widget.image.runtimeType}");
      }

      // 3. Send Request
      print("🚀 Sending request to $uri...");
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
        // Log error for debugging
        print("❌ SERVER ERROR: ${response.statusCode}");
        print("❌ RESPONSE BODY: $responseData");
        throw Exception(
          'Server returned ${response.statusCode}: $responseData',
        );
      }
    } catch (e) {
      print("🔥 EXCEPTION: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().substring(0, 50)}..."),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      Navigator.pop(context); // Return to preview page on error
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI Code remains the same...
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final double imageSize = isDesktop ? 300 : 200;
    final double titleSize = isDesktop ? 22 : 18;
    final double subtitleSize = isDesktop ? 16 : 14;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyzing Image..."),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 3,
        automaticallyImplyLeading: false, // Prevent back button during loading
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFFA5D6A7), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: _imageBytes == null
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : Image.memory(
                      _imageBytes!,
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 5,
                ),
                const SizedBox(height: 30),
                Text(
                  widget.useWeather
                      ? "Checking Weather & AI... 🌦️"
                      : "Connecting to AI Model... 🧠",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Sending data to server for analysis...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: subtitleSize,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

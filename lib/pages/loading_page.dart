import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // helpful for content types
import 'result_page.dart';

class LoadingPage extends StatefulWidget {
  final dynamic image; // File (mobile) or Uint8List (web)
  const LoadingPage({required this.image, super.key});

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
      _imageBytes = widget.image;
    } else if (widget.image is File) {
      _imageBytes = await (widget.image as File).readAsBytes();
    } else if (widget.image is Uint8List) {
      _imageBytes = widget.image;
    }
    setState(() {});
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

      // 1. Web Implementation (Already Good)
      if (kIsWeb && _imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            _imageBytes!,
            filename: 'leaf.jpg',
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }
      // 2. Mobile/Desktop Implementation (👇 THE FIX IS HERE)
      // For mobile/desktop - try without forcing filename extension
      else if (widget.image is File) {
        final file = widget.image as File;
        final extension = file.path.split('.').last.toLowerCase();

        request.files.add(
          await http.MultipartFile.fromPath(
            'file', // Must match FastAPI parameter name
            file.path,
            contentType: MediaType(
              'image',
              extension == 'png' ? 'png' : 'jpeg',
            ),
          ),
        );
      }

      // Send Request
      var response = await request.send();
      final responseData = await response.stream
          .bytesToString(); // Read response once

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(responseData);

        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                ResultPage(image: widget.image, analysisResult: jsonMap),
          ),
        );
      } else {
        // 👇 This helps you debug! It prints exactly why FastAPI rejected it.
        print("SERVER ERROR: ${response.statusCode}");
        print("ERROR BODY: $responseData");
        print("SERVER ERROR: ${response.statusCode}");
        throw Exception('Server error: ${response.statusCode} - $responseData');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString().substring(0, 50)}..."),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // Image preview container
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

                // Circular progress indicator
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 5,
                ),

                const SizedBox(height: 30),

                // Title
                Text(
                  "Connecting to AI Model... 🧠",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  "Sending data to local server for analysis...",
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

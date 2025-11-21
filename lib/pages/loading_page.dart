import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    await Future.delayed(const Duration(seconds: 3)); // Simulate analysis
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultPage(image: _imageBytes!),
      ),
    );
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
            colors: [
              Color(0xFFB2DFDB),
              Color(0xFFA5D6A7),
              Color(0xFF81C784),
            ],
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
                  "Analyzing your leaf... 🌿",
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
                  "Please wait while we detect the disease 🍃",
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
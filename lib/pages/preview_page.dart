import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'loading_page.dart';

class PreviewPage extends StatefulWidget {
  final dynamic image; // File (mobile) or Uint8List (web)
  const PreviewPage({required this.image, super.key});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  Uint8List? _imageBytes;
  bool _isRotating = false;

  @override
  void initState() {
    super.initState();
    _loadImageBytes();
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

  void _rotateImage() async {
    if (_imageBytes == null) return;
    setState(() => _isRotating = true);

    final decoded = img.decodeImage(_imageBytes!);
    if (decoded != null) {
      final rotated = img.copyRotate(decoded, angle: 90);
      _imageBytes = Uint8List.fromList(img.encodeJpg(rotated));
    }

    setState(() => _isRotating = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final double buttonWidth = isDesktop ? 180 : double.infinity;
    final double buttonFont = isDesktop ? 15 : 13;
    final double containerSize = isDesktop ? 400 : 280;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Photo"),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFFA5D6A7), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: _imageBytes == null
              ? const CircularProgressIndicator(color: Colors.white)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        height: containerSize,
                        width: containerSize,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white38),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          SizedBox(
                            width: buttonWidth,
                            child: ElevatedButton.icon(
                              onPressed: _isRotating ? null : _rotateImage,
                              icon: const Icon(Icons.rotate_right, size: 20),
                              label: Text(
                                "Rotate",
                                style: TextStyle(
                                  fontSize: buttonFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: buttonWidth,
                            child: ElevatedButton.icon(
                              onPressed: _isRotating
                                  ? null
                                  : () => Navigator.pop(context),
                              icon: const Icon(Icons.refresh, size: 20),
                              label: Text(
                                "Retake",
                                style: TextStyle(
                                  fontSize: buttonFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton.icon(
                          onPressed: _isRotating || _imageBytes == null
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          LoadingPage(image: _imageBytes!),
                                    ),
                                  );
                                },
                          icon: const Icon(Icons.analytics_outlined, size: 20),
                          label: const Text("Analyze Image"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2E7D32),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Rotate the image if needed before analysis 🌿",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: isDesktop ? 14 : 12,
                        ),
                      ),
                      if (_isRotating)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

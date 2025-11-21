import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'preview_page.dart';

class CapturePage extends StatefulWidget {
  const CapturePage({super.key});

  @override
  State<CapturePage> createState() => _CapturePageState();
}

class _CapturePageState extends State<CapturePage> {
  dynamic _image; // File (mobile) or Uint8List (web/desktop)

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);

    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() => _image = bytes);
      } else {
        setState(() => _image = File(picked.path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final double containerHeight = isDesktop ? 400 : 250;
    final double containerWidth = isDesktop ? 400 : double.infinity;
    final double buttonWidth = isDesktop ? 180 : double.infinity;

    return Scaffold(
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 50 : 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "📸 Capture or Upload Photo",
                    style: TextStyle(
                      fontSize: isDesktop ? 26 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isDesktop ? 35 : 20),

                  // Image Preview
                  Container(
                    height: containerHeight,
                    width: containerWidth,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white38),
                    ),
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: kIsWeb
                                ? Image.memory(
                                    _image,
                                    fit: BoxFit.contain,
                                  )
                                : Image.file(
                                    _image,
                                    fit: BoxFit.contain,
                                  ),
                          )
                        : Center(
                            child: Text(
                              "No photo selected",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: isDesktop ? 16 : 14),
                            ),
                          ),
                  ),
                  SizedBox(height: isDesktop ? 30 : 15),

                  // Capture / Upload Buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton.icon(
                          onPressed: () => _getImage(ImageSource.camera),
                          icon: Icon(Icons.camera_alt, size: 18),
                          label: const Text("Camera"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF388E3C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton.icon(
                          onPressed: () => _getImage(ImageSource.gallery),
                          icon: Icon(Icons.photo_library, size: 18),
                          label: const Text("Gallery"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF388E3C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isDesktop ? 25 : 15),

                  // Continue Button
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      onPressed: _image != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PreviewPage(image: _image),
                                ),
                              );
                            }
                          : null,
                      child: const Text("Continue"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _image != null
                            ? Colors.white
                            : Colors.white54,
                        foregroundColor: const Color(0xFF2E7D32),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(height: isDesktop ? 20 : 10),
                  Text(
                    "Select a healthy or infected tea leaf image 🌿",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: isDesktop ? 13 : 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
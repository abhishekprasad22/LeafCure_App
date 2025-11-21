import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final dynamic image; // File (mobile) or Uint8List (web)
  const ResultPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    const String disease = "Grey Blight";
    const String cure =
        "Spray copper oxychloride (2g/liter of water) every 10–15 days. "
        "Ensure proper drainage and remove infected leaves to prevent spread.";

    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    final double cardPadding = isDesktop ? 24 : 16;
    final double fontSize = isDesktop ? 16 : 14;
    final double imageHeight = isDesktop ? 300 : 220;
    final double cardWidth = isDesktop ? 500 : double.infinity;

    // Convert image to Uint8List if it's a File
    Uint8List? imageBytes;
    if (kIsWeb) {
      imageBytes = image as Uint8List;
    } else if (image is File) {
      imageBytes = File(image.path).readAsBytesSync();
    } else if (image is Uint8List) {
      imageBytes = image;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Prediction Result",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 4,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back arrow color set to white
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFC8E6C9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(cardPadding),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image Container
                Container(
                  width: isDesktop ? 450 : double.infinity,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: imageBytes == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Image.memory(
                            imageBytes,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                // Disease & Cure Card
                Container(
                  width: cardWidth,
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Predicted Disease",
                        style: TextStyle(
                          fontSize: isDesktop ? 22 : 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        disease,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isDesktop ? 26 : 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Divider(
                        color: Colors.green.shade200,
                        thickness: 1.2,
                        indent: 20,
                        endIndent: 20,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Cure / Treatment",
                        style: TextStyle(
                          fontSize: isDesktop ? 22 : 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cure,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Back Button
                SizedBox(
                  width: isDesktop ? 220 : double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    label: Text(
                      "Back",
                      style: TextStyle(fontSize: isDesktop ? 18 : 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                Text(
                  "Analyzed successfully 🌿",
                  style: TextStyle(
                    color: Colors.green[900]?.withOpacity(0.9),
                    fontSize: isDesktop ? 16 : 14,
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
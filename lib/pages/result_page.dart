import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final dynamic image; // File (mobile) or Uint8List (web)
  final Map<String, dynamic> analysisResult; // JSON data from backend

  const ResultPage({
    super.key,
    required this.image,
    required this.analysisResult,
  });

  // Helper to get formatted name
  String _formatName(String raw) {
    return raw
        .replaceAll('_', ' ')
        .split(' ')
        .map((str) {
          return str.isNotEmpty
              ? '${str[0].toUpperCase()}${str.substring(1)}'
              : '';
        })
        .join(' ');
  }

  // Helper to get Cure based on disease
  String _getCure(String diseaseKey) {
    switch (diseaseKey.toLowerCase()) {
      case 'brown_blight':
        return "Spray copper oxychloride (2g/liter) every 10–15 days. Improve drainage and avoid overcrowding of bushes.";
      case 'gray_blight':
        return "Remove infected leaves immediately. Apply systemic fungicides like Carbendazim.";
      case 'red_rust':
        return "Apply potassium fertilizers. Spray Bordeaux mixture (1%) during the dormant season.";
      case 'algal_leaf_spot':
        return "Prune infected branches. Ensure proper ventilation and sunlight penetration.";
      case 'healthy':
        return "Great job! Your tea plant is healthy. Keep maintaining good soil nutrition and hydration.";
      default:
        return "Consult a local agricultural expert for specific treatment advice.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;
    final double cardPadding = isDesktop ? 24 : 16;
    final double imageHeight = isDesktop ? 300 : 220;
    final double cardWidth = isDesktop ? 600 : double.infinity;

    // Extract Data from JSON
    final String predictionRaw =
        analysisResult['final_prediction'] ?? 'Unknown';
    final String predictionDisplay = _formatName(predictionRaw);
    final double confidence = analysisResult['final_confidence'] != null
        ? (analysisResult['final_confidence'] as num).toDouble()
        : 0.0;
    final int voteCount = analysisResult['vote_count'] ?? 0;
    final int totalModels = analysisResult['total_models'] ?? 0;
    final List details = analysisResult['details'] ?? [];

    // Image conversion
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
          "Analysis Report",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(cardPadding),
          child: Center(
            child: Column(
              children: [
                // 1. Image Card
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
                        ? const Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                          )
                        : Image.memory(imageBytes, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 25),

                // 2. Main Result Card
                Container(
                  width: cardWidth,
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Diagnosis Result",
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        predictionDisplay,
                        style: TextStyle(
                          fontSize: isDesktop ? 28 : 24,
                          fontWeight: FontWeight.w800,
                          color: predictionRaw.toLowerCase() == 'healthy'
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Confidence Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Confidence Level"),
                                Text("${confidence.toStringAsFixed(1)}%"),
                              ],
                            ),
                            const SizedBox(height: 5),
                            LinearProgressIndicator(
                              value: confidence / 100,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(5),
                              backgroundColor: Colors.grey[200],
                              color: confidence > 70
                                  ? Colors.green
                                  : (confidence > 40
                                        ? Colors.orange
                                        : Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      // AI Voting Summary
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.how_to_vote,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "$voteCount out of $totalModels AI models agreed on this result.",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: isDesktop ? 14 : 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // 3. Treatment Card (Only if not healthy)
                if (predictionRaw.toLowerCase() != 'healthy')
                  Container(
                    width: cardWidth,
                    padding: EdgeInsets.all(cardPadding),
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.medical_services_outlined,
                              color: Color(0xFF2E7D32),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Recommended Cure",
                              style: TextStyle(
                                fontSize: isDesktop ? 20 : 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _getCure(predictionRaw),
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                // 4. Model Details Expandable (Debug Info)
                ExpansionTile(
                  title: const Text("View AI Analysis Details"),
                  children: details.map<Widget>((model) {
                    return ListTile(
                      title: Text(model['model_name'] ?? 'Model'),
                      subtitle: Text(
                        "Transform: ${model['used_transform']} | Confidence: ${(model['confidence'] as num).toStringAsFixed(1)}%",
                      ),
                      trailing: Text(
                        _formatName(model['prediction'] ?? ''),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 30),

                // Back Button
                SizedBox(
                  width: isDesktop ? 220 : double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    label: const Text("Analyze Another"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
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

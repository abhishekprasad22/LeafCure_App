import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example static list; replace with local db or cloud data
    final pastPredictions = [
      {"disease": "Red Rust", "date": "06-11-2025"},
      {"disease": "Brown Blight", "date": "04-11-2025"},
      {"disease": "Healthy", "date": "03-11-2025"},
      {"disease": "Grey Blight", "date": "02-11-2025"},
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Past Predictions",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back arrow color set to white
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F5E9), // Light green background
              Color(0xFFC8E6C9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: isDesktop
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: pastPredictions.length,
                itemBuilder: (context, i) => _buildCard(pastPredictions[i], isDesktop),
              )
            : ListView.builder(
                itemCount: pastPredictions.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildCard(pastPredictions[i], isDesktop),
                ),
              ),
      ),
    );
  }

  Widget _buildCard(Map<String, String> entry, bool isDesktop) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.green.withOpacity(0.4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // On tap, show details or open previous result
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.local_florist,
                size: isDesktop ? 60 : 40,
                color: Colors.green[700],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tea Leaf Prediction",
                      style: TextStyle(
                        fontSize: isDesktop ? 22 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Disease: ${entry['disease']}",
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 14,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Date: ${entry['date']}",
                      style: TextStyle(
                        fontSize: isDesktop ? 16 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: isDesktop ? 24 : 18,
                color: Colors.green[700],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
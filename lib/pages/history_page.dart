import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Add intl to pubspec.yaml for date formatting

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Fetch predictions from Supabase
  Future<List<Map<String, dynamic>>> _fetchHistory() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await Supabase.instance.client
          .from('predictions')
          .select()
          .eq('user_id', userId) // Filter by current user
          .order('created_at', ascending: false); // Newest first

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching history: $e');
      return [];
    }
  }

  // Helper to get image URL
  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    // Generates the public URL for the image in the 'leaf_images' bucket
    return Supabase.instance.client.storage
        .from('leaf_images')
        .getPublicUrl(path);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Past Predictions", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2E7D32),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchHistory(),
          builder: (context, snapshot) {
            // 1. Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.green));
            }

            // 2. Error or Empty State
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off, size: 80, color: Colors.green[200]),
                    const SizedBox(height: 20),
                    Text(
                      "No history found.",
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Start analyzing leaves to build your record!",
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            // 3. Data Loaded
            final history = snapshot.data!;

            return isDesktop
                ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: history.length,
              itemBuilder: (context, i) => _buildCard(history[i], isDesktop),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildCard(history[i], isDesktop),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> entry, bool isDesktop) {
    // Parse Data
    final String prediction = entry['prediction'] ?? 'Unknown';
    final double confidence = (entry['confidence'] as num?)?.toDouble() ?? 0.0;
    final String dateStr = entry['created_at'] ?? DateTime.now().toIso8601String();
    final DateTime date = DateTime.parse(dateStr).toLocal();
    final String formattedDate = DateFormat('MMM d, y • h:mm a').format(date);
    final String imageUrl = _getImageUrl(entry['image_path']);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Optional: Navigate to a details page if you want
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Image Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: isDesktop ? 80 : 70,
                  height: isDesktop ? 80 : 70,
                  color: Colors.grey[200],
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
                  )
                      : const Icon(Icons.image, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      prediction.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        color: prediction.toLowerCase() == 'healthy'
                            ? Colors.green[700]
                            : Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Confidence: ${confidence.toStringAsFixed(1)}%",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

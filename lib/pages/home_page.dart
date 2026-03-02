import 'package:flutter/material.dart';
import 'capture_page.dart';
import 'history_page.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _useWeatherLogic = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB2DFDB), Color(0xFF81C784)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ---------------- Top Dashboard ----------------
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: isDesktop ? 40 : 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AccountPage()),
                      ),
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: isDesktop ? 30 : 26,
                      ),
                      tooltip: "Account",
                    ),
                    Text(
                      "Leafcure",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isDesktop ? 26 : 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),
                    SizedBox(width: isDesktop ? 30 : 26),
                  ],
                ),
              ),

              // ---------------- Main Content ----------------
              Expanded(
                child: Align(
                  alignment: const Alignment(0, -0.2),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 60 : 20,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '🍃 Tea Leaf Disease Detector',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isDesktop ? 30 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: isDesktop ? 40 : 30),

                          // App Logo
                          Container(
                            height: isDesktop ? 160 : 120,
                            width: isDesktop ? 160 : 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/app_logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          SizedBox(height: isDesktop ? 55 : 40),

                          // Buttons
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _useWeatherLogic
                                          ? Icons.cloud_done
                                          : Icons.cloud_off,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "AI + Weather Logic",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: _useWeatherLogic,
                                      activeColor: Colors.white,
                                      activeTrackColor: Colors.green[900],
                                      onChanged: (val) {
                                        setState(() => _useWeatherLogic = val);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width: double.infinity,
                                height: isDesktop ? 48 : 42,
                                child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    size: isDesktop ? 20 : 18,
                                  ),
                                  label: Text(
                                    "Click a Photo",
                                    style: TextStyle(
                                      fontSize: isDesktop ? 16 : 14,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF2E7D32),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CapturePage(
                                        useWeather: _useWeatherLogic,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: isDesktop ? 30 : 20),
                              SizedBox(
                                width: double.infinity,
                                height: isDesktop ? 48 : 42,
                                child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.history,
                                    size: isDesktop ? 20 : 18,
                                  ),
                                  label: Text(
                                    "Past Predictions",
                                    style: TextStyle(
                                      fontSize: isDesktop ? 16 : 14,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF388E3C),
                                    foregroundColor: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => HistoryPage(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'capture_page.dart';
import 'history_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "User";
  String userEmail = "Loading...";
  String? userAvatar;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        userName = user.userMetadata?['full_name'] ?? "Tea Farmer";
        userEmail = user.email ?? "";
        userAvatar = user.userMetadata?['avatar_url'];
      });
    }
  }

  // 1. Logout Feature Implementation
  Future<void> _handleLogout(
    BuildContext context, {
    bool isSwitching = false,
  }) async {
    try {
      // Sign out from Supabase (Backend)
      await Supabase.instance.client.auth.signOut();

      // Sign out from Google (Frontend - clears cached credentials)
      await GoogleSignIn().signOut();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isSwitching ? "Switching Account..." : "Logged out successfully",
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to Login Page and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error logging out: $e")));
      }
    }
  }

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
                  children: [
                    // ✅ Pop-up Menu for Logout/Switch
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'switch') {
                          _handleLogout(context, isSwitching: true);
                        } else if (value == 'logout') {
                          _handleLogout(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'switch',
                          child: Row(
                            children: [
                              Icon(Icons.switch_account, color: Colors.green),
                              SizedBox(width: 10),
                              Text("Switch Account"),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Log Out"),
                            ],
                          ),
                        ),
                      ],
                      child: CircleAvatar(
                        radius: isDesktop ? 22 : 18,
                        backgroundColor: Colors.white,
                        backgroundImage: userAvatar != null
                            ? NetworkImage(userAvatar!)
                            : null,
                        child: userAvatar == null
                            ? Icon(
                                Icons.person,
                                color: Colors.green,
                                size: isDesktop ? 26 : 20,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $userName",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 20 : 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userEmail,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: isDesktop ? 16 : 12,
                          ),
                        ),
                      ],
                    ),
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
                                      builder: (_) => CapturePage(),
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

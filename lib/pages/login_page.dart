import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);

    try {
      // 👇 REPLACE THIS with your actual Web Client ID from Google Cloud
      const webClientId =
          '402184687940-bpst73bofpvb6isv01pmjhkfsrbuthcu.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the login
        setState(() => _isLoading = false);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'No Access Token found.';
      }

      // Sign in to Supabase
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      // Success! Go to Home Page
      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login Failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 700;

    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? size.width * 0.3 : 24,
            vertical: 24,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/app_logo.png',
                  width: isDesktop ? 160 : 120,
                  height: isDesktop ? 160 : 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "LeafCure",
                style: TextStyle(
                  fontSize: isDesktop ? 30 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Detect & Manage Tea Leaf Diseases",
                style: TextStyle(
                  fontSize: isDesktop ? 18 : 14,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // 👇 UPDATED BUTTON
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.green)
                  : ElevatedButton.icon(
                      onPressed: _googleSignIn, // Calls the function above
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text(
                        "Login with Google",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 50 : 30,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
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















// import 'package:flutter/material.dart';
// import 'home_page.dart';

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final isDesktop = size.width > 700;

//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(
//             horizontal: isDesktop ? size.width * 0.3 : 24,
//             vertical: 24,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // App Logo
//               ClipOval(
//                 child: Image.asset(
//                   'assets/app_logo.png',
//                   width: isDesktop ? 160 : 120,
//                   height: isDesktop ? 160 : 120,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Title
//               Text(
//                 "LeafCure",
//                 style: TextStyle(
//                   fontSize: isDesktop ? 30 : 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green[900],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 8),

//               Text(
//                 "Detect & Manage Tea Leaf Diseases",
//                 style: TextStyle(
//                   fontSize: isDesktop ? 18 : 14,
//                   color: Colors.grey[700],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),

//               // Login Button
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (_) => HomePage()),
//                   );
//                 },
//                 icon: const Icon(Icons.login, color: Colors.white),
//                 label: const Text(
//                   "Login with Google",
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: isDesktop ? 50 : 30,
//                     vertical: 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
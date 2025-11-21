// import 'package:flutter/material.dart';
// import 'pages/login_page.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tea Leaf Disease Detector',
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: LoginPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import './pages/login_page.dart'; // Check this path matches your folder structure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 👇 Initialize Supabase here
  await Supabase.initialize(
    url:
        'https://ljyroclvlsgvsrudgarl.supabase.co', // Paste from Supabase Settings > API
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxqeXJvY2x2bHNndnNydWRnYXJsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM0MzkwMTksImV4cCI6MjA3OTAxNTAxOX0.fRSK8CgHHKU-UEqRC5Xaen3FI-Y4tXF-8pVaYepEW3g', // Paste from Supabase Settings > API
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tea Leaf Disease Detector',
      theme: ThemeData(primarySwatch: Colors.green),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

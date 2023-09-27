import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:joint_stats_official/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: SplashScreen(),
          ),
        ),
      ),
    );
  }
}

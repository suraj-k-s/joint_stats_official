import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joint_stats_official/login_page.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      // User is already logged in, navigate to HomePage
      Timer(const Duration(seconds: 6), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      });
    } else {
      // User is not logged in, navigate to LoginPage

      Timer(const Duration(seconds: 6), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 254),
      body: Center(
        child: Lottie.asset(
          'assets/splashScreen.json',
          width: 400,
          height: 800,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}


//        child: ColorFiltered(
//           colorFilter: const ColorFilter.mode(
//             Colors.blue, // Set the color of the animation here
//             BlendMode.modulate,
//           ),
//           child: Lottie.asset(
//             'assets/splashScreen.json',
//             width: 400,
//             height: 600,
//             fit: BoxFit.fill,
//           ),
//         ),
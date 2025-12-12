import 'package:flutter/material.dart';
import 'dart:async';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeIn),
    );

    fadeController.forward();

    // Pindah ke login setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // ---------- Gradient Background ----------
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff95d1fc), // Biru dominan
              Color(0xffffffff), // Putih
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: FadeTransition(
          opacity: fadeAnimation,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // -------- LOGO --------
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      spreadRadius: 2,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/icons/transicon.png",
                  width: 150,
                  height: 150,
                ),
              ),

              const SizedBox(height: 30),

              // -------- Teks Selamat Datang --------
              Text(
                "Selamat Datang di",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.85),
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.7),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "WarungKu",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.black.withOpacity(0.9),
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.8),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // -------- Loading Indicator --------
              const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Color(0xff1e80d4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

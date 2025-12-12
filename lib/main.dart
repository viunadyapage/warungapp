import 'package:flutter/material.dart';
import 'package:warungapp/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Crimson Pro',
      ),
      home: const SplashScreen(),
    );
  }
}
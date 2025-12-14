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
        fontFamily: 'CrimsonPro',
        textTheme: const TextTheme(
          bodySmall: TextStyle(fontFamily: 'CrimsonPro'),
          bodyMedium: TextStyle(fontFamily: 'CrimsonPro'),
          bodyLarge: TextStyle(fontFamily: 'CrimsonPro'),
          titleSmall: TextStyle(fontFamily: 'CrimsonPro'),
          titleMedium: TextStyle(fontFamily: 'CrimsonPro'),
          titleLarge: TextStyle(fontFamily: 'CrimsonPro'),
        ),
      ),

      home: const SplashScreen(),
    );
  }
}

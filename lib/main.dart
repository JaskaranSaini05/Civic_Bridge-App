import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const CivicBridgeApp());
}

class CivicBridgeApp extends StatelessWidget {
  const CivicBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Civic Bridge",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      
      home: const SplashScreen(),
    );
  }
}
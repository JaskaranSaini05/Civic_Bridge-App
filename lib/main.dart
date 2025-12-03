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
      debugShowCheckedModeBanner: false,
      title: 'Civic Bridge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

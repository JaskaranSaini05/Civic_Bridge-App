import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),

          Center(
            child: Image.asset(
              "assets/logo.png",
              height: 180,
              width: 180,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 30),

          Text(
            "Civic Bridge",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Report • Resolve • Rebuild",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Together we improve communities",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

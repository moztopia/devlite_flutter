import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final String message;
  final double progress;

  const SplashScreen(
      {super.key, required this.message, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF2196F3),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flutter_dash,
                    size: 100, color: Color(0xFFFFFFFF)),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: const Color(0x66FFFFFF),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                  minHeight: 8.0,
                ),
              ],
            ),
          ),
        ));
  }
}

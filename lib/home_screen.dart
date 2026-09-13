import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 7, 7), // Maroon turned to black background
      body: Center(
        child: Text(
          'Welcome to Homework Tracker',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 251, 250, 250), // Pink text for contrast
          ),
        ),
      ),
    );
  }
}
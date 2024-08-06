import 'package:flutter/material.dart';

class Xtreme extends StatelessWidget {
  const Xtreme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              Icons.construction,
              size: 50,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}

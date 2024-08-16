import 'package:flutter/material.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Text(
          'Contact Us',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          'If you have any questions about this app, you can contact us:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
        ListTile(
          title: Text('By email: sokkercuba@gmail.com'),
        ),
        ListTile(
          title: Text('By filling a form: coming soon...'),
        ),
      ],
    );
  }
}

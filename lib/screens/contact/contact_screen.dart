import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollToTopOnMount(),
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
        ),
      ),
    );
  }
}

class ScrollToTopOnMount extends StatefulWidget {
  const ScrollToTopOnMount({super.key});

  @override
  State<ScrollToTopOnMount> createState() => _ScrollToTopOnMountState();
}

class _ScrollToTopOnMountState extends State<ScrollToTopOnMount> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollToTop();
    });
  }

  void _scrollToTop() {
    Scrollable.ensureVisible(context);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

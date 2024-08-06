import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[200]
          : Colors.grey[900],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16.0,
            children: [
              FooterLink(
                text: "Home",
                icon: Icons.home,
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              FooterLink(
                text: "Contact",
                icon: Icons.contact_mail,
                onTap: () {
                  Navigator.pushNamed(context, '/contact');
                },
              ),
            ],
          ),
          const Divider(height: 32.0, thickness: 1.0),
          const Text(
            'The Cuban Sokker community!',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Copyright © Sokker Cuba ${DateTime.now().year}',
            style: const TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const FooterLink({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20.0),
            const SizedBox(width: 8.0),
            Text(text, style: const TextStyle(fontSize: 14.0)),
          ],
        ),
      ),
    );
  }
}

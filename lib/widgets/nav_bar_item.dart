import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final String path;
  final IconData icon;
  final String value;
  final void Function()? onTap;

  const NavBarItem({
    super.key,
    required this.path,
    required this.icon,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(value),
      onTap: onTap,
    );
  }
}

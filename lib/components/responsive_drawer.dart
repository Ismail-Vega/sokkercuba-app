import 'package:flutter/material.dart';

import '../screens/footer/footer_screen.dart';
import 'drawer_content.dart';

class ResponsiveDrawer extends StatefulWidget {
  final Widget child;
  final void Function(ThemeMode) setSelectedTheme;

  const ResponsiveDrawer({
    super.key,
    required this.child,
    required this.setSelectedTheme,
  });

  @override
  State<ResponsiveDrawer> createState() {
    return _ResponsiveDrawerState();
  }
}

class _ResponsiveDrawerState extends State<ResponsiveDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Sokker Pro'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(Theme.of(context).brightness == Brightness.dark
                    ? 'Light Mode'
                    : 'Dark Mode'),
                const SizedBox(width: 8),
                Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    widget.setSelectedTheme(
                        value ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width,
        child: DrawerContent(
          setSelectedTheme: widget.setSelectedTheme,
        ),
      ),
      body: Container(
        color: Colors.blue[900], // Main background color
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SafeArea(child: widget.child),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Footer(),
            ),
          ],
        ),
      ),
    );
  }
}

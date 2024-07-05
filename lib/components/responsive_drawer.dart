import 'package:flutter/material.dart';

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
        title: const Text('Sokkercuba'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
      ),
      drawer: Drawer(
        child: DrawerContent(
          setSelectedTheme: widget.setSelectedTheme,
        ),
      ),
      body: widget.child,
    );
  }
}

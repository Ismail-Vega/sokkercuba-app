import 'package:flutter/material.dart';

import '../models/navigation/nav_bar_item_model.dart';
import '../widgets/nav_bar_item.dart';

class DrawerContent extends StatelessWidget {
  final void Function(ThemeMode) setSelectedTheme;

  const DrawerContent({super.key, required this.setSelectedTheme});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Stack(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/logo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CloseButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        for (var item in drawerPublicItems)
          NavBarItem(
            icon: item.icon,
            path: item.path,
            value: item.value,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, item.path);
            },
          ),
        const Divider(),
        for (var item in drawerPrivateItems)
          NavBarItem(
            icon: item.icon,
            path: item.path,
            value: item.value,
            onTap: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, item.path);
            },
          ),
      ],
    );
  }
}

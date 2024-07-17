import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/navigation/nav_bar_item_model.dart';
import '../services/api_client.dart';
import '../state/actions.dart';
import '../state/app_state_notifier.dart';
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
                  image: AssetImage('assets/images/logo/logo.jpg'),
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
        const Divider(),
        NavBarItem(
          icon: Icons.logout,
          path: '/login',
          value: 'Logout',
          onTap: () async {
            final appStateNotifier =
                Provider.of<AppStateNotifier>(context, listen: false);

            try {
              appStateNotifier
                  .dispatch(StoreAction(StoreActionTypes.setLoading, true));

              final apiClient = ApiClient();
              await apiClient.initCookieJar();

              final response = await apiClient.sendData('/auth/logout', {});

              if (response != null && context.mounted) {
                Navigator.pushNamed(context, '/login');
              }
            } catch (error) {
              if (context.mounted) {
                Navigator.pushNamed(context, '/login');
              }
              throw Exception('Failed to logout: $error');
            } finally {
              appStateNotifier
                  .dispatch(StoreAction(StoreActionTypes.setLoading, false));
            }
          },
        ),
      ],
    );
  }
}

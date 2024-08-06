import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/navigation/nav_bar_item_model.dart';
import '../services/api_client.dart';
import '../services/fetch_all_data.dart';
import '../state/actions.dart';
import '../state/app_state_notifier.dart';
import '../widgets/nav_bar_item.dart';

class DrawerContent extends StatefulWidget {
  final void Function(ThemeMode) setSelectedTheme;
  final VoidCallback closeDrawer;

  const DrawerContent(
      {super.key, required this.setSelectedTheme, required this.closeDrawer});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  bool isLoading = false;

  Future<void> _updateData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final apiClient = ApiClient();
    await apiClient.initCookieJar();

    if (!context.mounted) return;

    final appStateNotifier =
        Provider.of<AppStateNotifier>(context, listen: false);

    await fetchAllData(apiClient, appStateNotifier);

    widget.closeDrawer();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900] ?? Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Navigation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.update, color: Colors.white),
                    label: const Text(
                      'Update my data',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () async {
                      await _updateData(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        if (isLoading) const LinearProgressIndicator(),
        const Divider(),
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

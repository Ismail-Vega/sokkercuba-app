import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/navigation/nav_bar_item_model.dart';
import '../screens/footer/footer_screen.dart';
import '../services/api_client.dart';
import '../services/fetch_all_data.dart';
import '../services/toast_service.dart';
import '../state/actions.dart';
import '../state/app_state_notifier.dart';
import '../themes/custom_extension.dart';
import '../utils/format.dart';
import '../widgets/nav_bar_item.dart';

class DrawerContent extends StatefulWidget {
  final VoidCallback closeDrawer;

  const DrawerContent({
    super.key,
    required this.closeDrawer,
  });

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  bool isLoading = false;

  Future<void> _updateData(BuildContext context) async {
    final toastService = ToastService(context);

    setState(() {
      isLoading = true;
    });

    final apiClient = ApiClient();
    await apiClient.initCookieJar();

    if (!context.mounted) return;

    final appStateNotifier =
        Provider.of<AppStateNotifier>(context, listen: false);

    final result = await fetchAllData(apiClient, appStateNotifier, context);

    if (result['code'] == 200 && result['success'] == true) {
      widget.closeDrawer();

      setState(() {
        isLoading = false;
      });

      if (!context.mounted) return;

      final currentPath = ModalRoute.of(context)?.settings.name;

      if (currentPath != null) {
        Navigator.pushReplacementNamed(context, currentPath);
      }

      toastService.showToast(
        'Data updated on! ${formatDateTime(result['dataUpdatedOn'])}',
        backgroundColor: Colors.green,
      );
    } else {
      toastService.showToast(
        "Failed to fetch all data!",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<CustomThemeExtension>()!;

    return Column(
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
              padding: const EdgeInsets.fromLTRB(18, 40, 18, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Navigation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: customTheme.mediumFontSize,
                      fontWeight: FontWeight.bold,
                    ),
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
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
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
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Import your data'),
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final appStateNotifier =
                      Provider.of<AppStateNotifier>(context, listen: false);
                  await appStateNotifier.importAppStateWithFilePicker(context);
                  setState(() {
                    isLoading = false;
                  });
                  widget.closeDrawer();
                },
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Export your data'),
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final appStateNotifier =
                      Provider.of<AppStateNotifier>(context, listen: false);
                  await appStateNotifier.exportAppStateWithFilePicker(context);
                  setState(() {
                    isLoading = false;
                  });
                  widget.closeDrawer();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.update,
                  color: Colors.white,
                  size: 24,
                ),
                title: const Text(
                  'Update your data',
                ),
                onTap: () async {
                  await _updateData(context);
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
                    appStateNotifier.dispatch(
                        StoreAction(StoreActionTypes.setLoading, true));

                    final apiClient = ApiClient();
                    await apiClient.initCookieJar();

                    final response =
                        await apiClient.sendData('/auth/logout', {});

                    if (response != null && context.mounted) {
                      Navigator.pushNamed(context, '/login');
                      appStateNotifier.dispatch(
                          StoreAction(StoreActionTypes.setLogin, false));
                    }
                  } catch (error) {
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/login');
                      appStateNotifier.dispatch(
                          StoreAction(StoreActionTypes.setLogin, false));
                    }
                    throw Exception('Failed to logout: $error');
                  } finally {
                    appStateNotifier.dispatch(
                        StoreAction(StoreActionTypes.setLoading, false));
                  }
                },
              ),
            ],
          ),
        ),
        const Footer(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../state/app_state_notifier.dart';
import '../themes/custom_extension.dart';
import 'drawer_content.dart';

class ResponsiveDrawer extends StatefulWidget {
  final Widget child;

  const ResponsiveDrawer({
    super.key,
    required this.child,
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

  void _closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AppStateNotifier>(context).state.loading;
    final customTheme = Theme.of(context).extension<CustomThemeExtension>();

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Sokker Pro',
            style: TextStyle(fontSize: customTheme?.mediumFontSize),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: _openDrawer,
          ),
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width,
          child: DrawerContent(
            closeDrawer: _closeDrawer,
          ),
        ),
        body: Container(
          color: Colors.blue,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sokkercuba/screens/login_screen.dart';
import 'package:sokkercuba/screens/welcome_screen.dart';
import 'package:sokkercuba/state/app_state.dart';
import 'package:sokkercuba/state/app_state_notifier.dart';

import 'components/responsive_drawer.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the initial state from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final stateString = prefs.getString('appState');
  AppState initialState = AppState(
    error: false,
    errorMsg: null,
    username: '',
    teamId: null,
    loading: false,
    loggedIn: false,
    user: null,
    juniors: null,
    cweek: null,
    tsummary: null,
    players: null,
    training: null,
  );
  if (stateString != null) {
    initialState = AppState.fromJson(jsonDecode(stateString));
  }

  runApp(Sokkercuba(initialState: initialState));
}

class Sokkercuba extends StatefulWidget {
  final AppState initialState;

  const Sokkercuba({super.key, required this.initialState});

  @override
  State<Sokkercuba> createState() {
    return _SokkercubaState();
  }
}

class _SokkercubaState extends State<Sokkercuba> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _setSelectedTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStateNotifier(widget.initialState),
      child: MaterialApp(
        builder: FToastBuilder(),
        navigatorKey: navigatorKey,
        title: 'Sokkercuba App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: _themeMode,
        home: ResponsiveDrawer(
          setSelectedTheme: _setSelectedTheme,
          child: const WelcomeScreen(),
        ),
        onGenerateRoute: _generateRoute,
        initialRoute: '/login',
      ),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/':
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      /*case '/about':
        return MaterialPageRoute(builder: (context) => AboutPage());
      case '/contact':
        return MaterialPageRoute(builder: (context) => ContactPage());
      case '/addon':
        return MaterialPageRoute(builder: (context) => AddonPage());
      case '/addon/privacy':
        return MaterialPageRoute(builder: (context) => AddonPrivacyPage());*/
      /*case '/signup':
        return MaterialPageRoute(builder: (context) => SignUp());
      case '/xtreme':
        return MaterialPageRoute(builder: (context) => XtremePage());
      case '/squad':
        return MaterialPageRoute(builder: (context) => TeamPage());
      case '/training':
        return MaterialPageRoute(builder: (context) => TrainingPage());
      case '/update':
        return MaterialPageRoute(builder: (context) => UpdatePage());*/
      default:
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
    }
  }
}

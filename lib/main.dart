import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sokkercuba/screens/home/welcome_screen.dart';
import 'package:sokkercuba/screens/login_screen.dart';
import 'package:sokkercuba/state/app_state.dart';
import 'package:sokkercuba/state/app_state_notifier.dart';

import 'components/responsive_drawer.dart';
import 'screens/scouting/scouting_screen.dart';
import 'screens/xtreme/xtreme_screen.dart';
import 'services/api_client.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    userStats: null,
    juniors: null,
    cweek: null,
    tsummary: null,
    players: null,
    training: null,
  );

  if (stateString != null) {
    initialState = AppState.fromJson(jsonDecode(stateString));
  }

  final apiClient = ApiClient();
  bool isLoggedIn = false;
  await apiClient.initCookieJar();

  try {
    final currentResponse = await apiClient.fetchData('/current');
    if (currentResponse != null) {
      isLoggedIn = true;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Exception while checking api auth: $e');
    }
  }

  runApp(Sokkercuba(
    initialState: initialState,
    isLoggedIn: isLoggedIn,
  ));
}

class Sokkercuba extends StatefulWidget {
  final AppState initialState;
  final bool isLoggedIn;

  const Sokkercuba(
      {super.key, required this.initialState, required this.isLoggedIn});

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
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: Colors.blue[900],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blueAccent,
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.blue,
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.blueAccent,
          ),
        ),
        themeMode: _themeMode,
        home: ResponsiveDrawer(
          setSelectedTheme: _setSelectedTheme,
          child:
              widget.isLoggedIn ? const WelcomeScreen() : const LoginScreen(),
        ),
        onGenerateRoute: _generateRoute,
        initialRoute: '/',
      ),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => ResponsiveDrawer(
                setSelectedTheme: _setSelectedTheme,
                child: const WelcomeScreen()));
      case '/xtreme':
        return MaterialPageRoute(
            builder: (context) => ResponsiveDrawer(
                setSelectedTheme: _setSelectedTheme, child: const Xtreme()));
      case '/scouting':
        return MaterialPageRoute(
            builder: (context) => ResponsiveDrawer(
                setSelectedTheme: _setSelectedTheme, child: const Scouting()));
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
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
      case '/squad':
        return MaterialPageRoute(builder: (context) => TeamPage());
      case '/training':
        return MaterialPageRoute(builder: (context) => TrainingPage());
      case '/update':
        return MaterialPageRoute(builder: (context) => UpdatePage());*/
      default:
        return MaterialPageRoute(
            builder: (context) => ResponsiveDrawer(
                setSelectedTheme: _setSelectedTheme,
                child: const WelcomeScreen()));
    }
  }
}

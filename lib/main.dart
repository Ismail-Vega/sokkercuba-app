import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'components/responsive_drawer.dart';
import 'constants/constants.dart';
import 'models/player/player.dart';
import 'models/team/user.dart';
import 'screens/contact/contact_screen.dart';
import 'screens/home/welcome_screen.dart';
import 'screens/juniors/juniors_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/scouting/scouting_screen.dart';
import 'screens/squad/squad_screen.dart';
import 'screens/training/training_screen.dart';
import 'screens/xtreme/xtreme_screen.dart';
import 'services/api_client.dart';
import 'services/transfers.dart';
import 'state/actions.dart';
import 'state/app_state.dart';
import 'state/app_state_notifier.dart';
import 'themes/custom_extension.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  final prefs = await SharedPreferences.getInstance();
  final stateString = prefs.getString('appState');
  AppState initialState = AppState(
    error: false,
    errorMsg: null,
    username: '',
    teamId: null,
    loading: false,
    transfersLoading: false,
    loggedIn: false,
    user: null,
    userStats: null,
    juniors: null,
    tsummary: null,
    players: null,
    training: null,
    observedPlayers: [],
  );

  if (stateString != null) {
    initialState = AppState.fromJson(jsonDecode(stateString));
  }

  final apiClient = ApiClient();
  await apiClient.initCookieJar();

  try {
    final currentResponse = await apiClient.fetchData(userUrl);
    if (currentResponse != null) {
      initialState = initialState.copyWith(
        loggedIn: true,
        user: User.fromJson(currentResponse),
      );
    } else {
      initialState = initialState.copyWith(loggedIn: false);
    }
  } catch (e) {
    if (kDebugMode) {
      print('Exception while checking api auth: $e');
    }
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppStateNotifier(initialState),
      child: const SokkerPro(),
    ),
  );
}

class SokkerPro extends StatefulWidget {
  const SokkerPro({super.key});

  @override
  State<SokkerPro> createState() => _SokkerProState();
}

class _SokkerProState extends State<SokkerPro> {
  @override
  void initState() {
    super.initState();
    _scheduleDailyTransferFetch();
  }

  void _scheduleDailyTransferFetch() async {
    final appStateNotifier =
        Provider.of<AppStateNotifier>(context, listen: false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? lastTransfersFetchDate =
        prefs.getString('lastTransfersFetchDate');

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime.local(now.year, now.month, now.day, 8);

    if (lastTransfersFetchDate != null) {
      try {
        final lastFetchDate =
            tz.TZDateTime.parse(tz.local, lastTransfersFetchDate);
        if (now.difference(lastFetchDate).inDays < 1 &&
            now.isBefore(scheduledTime)) {
          return;
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error parsing lastTransfersFetchDate: $e");
        }
      }
    }

    await _fetchTransfers(appStateNotifier);
    await prefs.setString('lastTransfersFetchDate',
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}');

    final durationUntil8AM =
        scheduledTime.add(const Duration(days: 1)).difference(now);
    Timer(durationUntil8AM, () async {
      await _fetchTransfers(appStateNotifier);
      await prefs.setString('lastTransfersFetchDate',
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}');
    });
  }

  Future<void> _fetchTransfers(AppStateNotifier appStateNotifier) async {
    appStateNotifier
        .dispatch(StoreAction(StoreActionTypes.setTransfersLoading, true));

    try {
      String? countryName = appStateNotifier.state.user?.team.country?.name;

      if (countryName != null) {
        List<TeamPlayer> fetchedPlayers = await fetchTransfersByCountry(
          ApiClient(),
          countryName,
          appStateNotifier.state.observedPlayers,
        );

        appStateNotifier.dispatch(StoreAction(
            StoreActionTypes.updateObservedPlayers, fetchedPlayers));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching transfers: $e");
      }
    } finally {
      appStateNotifier
          .dispatch(StoreAction(StoreActionTypes.setTransfersLoading, false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appStateNotifier, child) {
        final appState = appStateNotifier.state;
        final customTheme = CustomThemeExtension.of(context);

        return MaterialApp(
          builder: FToastBuilder(),
          navigatorKey: navigatorKey,
          title: 'Sokker Pro App',
          theme: ThemeData.light().copyWith(
            extensions: [customTheme],
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.blue[900],
            ),
            buttonTheme: const ButtonThemeData(
              buttonColor: Colors.blue,
            ),
            drawerTheme: DrawerThemeData(
              backgroundColor: Colors.blue[900],
            ),
            extensions: [customTheme],
          ),
          themeMode: ThemeMode.dark,
          home: appState.loggedIn
              ? ResponsiveDrawer(child: WelcomeScreen(user: appState.user))
              : const LoginScreen(),
          onGenerateRoute: (settings) => _generateRoute(settings, appState),
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings, AppState appState) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) =>
                const ResponsiveDrawer(child: WelcomeScreen()));
      case '/xtreme':
        return MaterialPageRoute(
            builder: (context) => const ResponsiveDrawer(child: Xtreme()));
      case '/scouting':
        return MaterialPageRoute(
            builder: (context) => const ResponsiveDrawer(child: Scouting()));
      case '/contact':
        return MaterialPageRoute(
            builder: (context) => const ResponsiveDrawer(child: Contact()));
      case '/squad':
        return MaterialPageRoute(
            builder: (context) => const ResponsiveDrawer(child: SquadScreen()));
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case '/training':
        return MaterialPageRoute(
            builder: (context) => const ResponsiveDrawer(child: Training()));
      case '/juniors':
        return MaterialPageRoute(
            builder: (context) =>
                const ResponsiveDrawer(child: JuniorsScreen()));
      default:
        return MaterialPageRoute(
            builder: (context) =>
                const ResponsiveDrawer(child: WelcomeScreen()));
    }
  }
}

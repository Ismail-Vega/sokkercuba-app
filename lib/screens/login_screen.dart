import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:sokkercuba/utils/constants.dart';
import 'package:sokkercuba/widgets/rounded_button.dart';

import '../models/team/team_stats.dart';
import '../models/team/user.dart';
import '../models/tsummary/tsummary.dart';
import '../services/api_client.dart';
import '../state/app_state.dart';
import '../state/app_state_notifier.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  late String login;
  late String password;
  final _formKey = GlobalKey<FormState>();

  void _toggleSpinner(bool value) {
    setState(() {
      showSpinner = value;
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      _toggleSpinner(true);

      try {
        final apiClient = ApiClient();
        await apiClient.initCookieJar();
        final response = await apiClient.sendData(
          '/auth/login',
          {'login': login, 'password': password, 'remember': true},
        );

        if (response.statusCode == 200) {
          final userDataResponse = await apiClient.fetchData('/current');

          if (userDataResponse != null) {
            final user = User.fromJson(userDataResponse);

            List<Future<dynamic>> requests = [
              apiClient.fetchData('/team/${user.team.id}/stats'),
              apiClient.fetchData('/training/summary'),
            ];

            List<dynamic> responses = await Future.wait(requests);

            var userStatsResponse = responses[0];
            var tsummaryResponse = responses[1];

            if (userStatsResponse != null &&
                tsummaryResponse != null &&
                mounted) {
              final userStats = UserStats.fromJson(userStatsResponse);
              final tsummary = TSummary.fromJson(userStatsResponse);

              final appStateNotifier =
                  Provider.of<AppStateNotifier>(context, listen: false);

              appStateNotifier.dispatch(
                  StoreAction(StoreActionTypes.setUserStats, userStats));
              appStateNotifier
                  .dispatch(StoreAction(StoreActionTypes.setSummary, tsummary));
              appStateNotifier
                  .dispatch(StoreAction(StoreActionTypes.setUser, user));

              Navigator.pushNamed(context, '/');
            }
          } else {
            Fluttertoast.showToast(
                msg: "Failed to fetch user data!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: "There was an error while login you in!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Incorrect login info, please try again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } finally {
        _toggleSpinner(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 100.0,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.lock_outline,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    login = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Login cannot be empty';
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your username',
                    helperText: ' ',
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    return null;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                    helperText: ' ',
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Log In',
                  colour: Colors.blue,
                  onPressed: _handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

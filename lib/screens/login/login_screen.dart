import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../models/team/user.dart';
import '../../services/api_client.dart';
import '../../services/fetch_all_data.dart';
import '../../state/actions.dart';
import '../../state/app_state_notifier.dart';
import '../../utils/constants.dart';
import '../../utils/is_date_today.dart';
import '../../widgets/rounded_button.dart';

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

        if (response.statusCode == 200 && mounted) {
          final appStateNotifier =
              Provider.of<AppStateNotifier>(context, listen: false);
          final stateUser = appStateNotifier.state.user;

          appStateNotifier
              .dispatch(StoreAction(StoreActionTypes.setLogin, true));
          appStateNotifier
              .dispatch(StoreAction(StoreActionTypes.setUsername, login));

          if (stateUser != null && isDateToday(stateUser.today.date.value)) {
            Navigator.pushNamed(context, '/');
          } else {
            final userDataResponse = await apiClient.fetchData('/current');

            if (userDataResponse != null) {
              final user = User.fromJson(userDataResponse);
              final allDataResponse =
                  await fetchAllData(apiClient, user, appStateNotifier.state);

              if (allDataResponse['code'] == 200 && mounted) {
                final filteredPayload = {
                  'teamId': userDataResponse['team']?['id'],
                  'user': User.fromJson(userDataResponse),
                  'userStats': allDataResponse['userStats'],
                  'juniors': allDataResponse['juniors'],
                  'tsummary': allDataResponse['tsummary'],
                  'players': allDataResponse['players'],
                  'training': allDataResponse['training'],
                  'news': allDataResponse['news'],
                };

                appStateNotifier.dispatch(
                    StoreAction(StoreActionTypes.setAll, filteredPayload));

                Navigator.pushNamed(context, '/');
              } else {
                Fluttertoast.showToast(
                    msg: "Failed to fetch all data!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Failed to fetch all data!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        } else {
          if (response.statusCode == 401) {
            Fluttertoast.showToast(
                msg: "Incorrect login info, please try again!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            Fluttertoast.showToast(
                msg: "There was an error while logging you in!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('catch: $e');
        }
        Fluttertoast.showToast(
            msg: "There was an error while logging you in!",
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

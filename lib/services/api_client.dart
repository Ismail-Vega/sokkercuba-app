import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart';

import '../main.dart';

class ApiClient {
  late Dio _dio;
  late PersistCookieJar _cookieJar;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://sokker.org/api',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
    _init();
  }

  Future<void> _init() async {
    await initCookieJar();
  }

  Future<void> initCookieJar() async {
    if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    if (Platform.isIOS) SharedPreferencesFoundation.registerWith();

    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = '${appDocDir.path}/.cookies';

    _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
  }

  Future<dynamic> sendData(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    try {
      final cookies =
          await _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl));

      String cookiesString =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      final options = Options(
        headers: {
          'Cookie': cookiesString,
          //'Cookie':             'PHPSESSID=1jij5r4r1a7s8u37cd8lhqcegk; lang=en; lang_ID=2; _html_rtl=0',
        },
      );

      final isLogout = endpoint == '/auth/logout';

      final response = await _dio.post(endpoint,
          data: data, options: isLogout ? options : null);

      final setCookies = response.headers.map['set-cookie'];
      print('post cookies: $setCookies');

      if (setCookies != null && endpoint == '/auth/login') {
        await _cookieJar.saveFromResponse(Uri.parse('https://sokker.org/api'),
            setCookies.map((str) => Cookie.fromSetCookieValue(str)).toList());
      }

      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Exception while sending data: $e');
      }
    }
  }

  Future<dynamic> fetchData(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final cookies =
          await _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl));

      String cookiesString =
          cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');

      print('fetch cookies: $cookiesString');
      final options = Options(
        headers: {
          'Cookie': cookiesString,
          //'Cookie':             'PHPSESSID=1jij5r4r1a7s8u37cd8lhqcegk; lang=en; lang_ID=2; _html_rtl=0',
        },
      );

      final response = await _dio.get(endpoint, options: options);
      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print('Exception while fetching data: $e');
      }
      return null;
    }
  }

  Future<dynamic> _handleResponse(Response response) async {
    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 401) {
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      return null;
    } else {
      if (kDebugMode) {
        print('Failed to handle response. Status code: ${response.statusCode}');
      }
      return null;
    }
  }
}

import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
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
        'Accept': '*/*',
        'Content-Type': 'application/json',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br'
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
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<dynamic> sendData(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      final cookies = response.headers.map['set-cookie'];

      if (cookies != null && endpoint == '/auth/login') {
        await _cookieJar.saveFromResponse(Uri.parse('https://sokker.org'),
            cookies.map((str) => Cookie.fromSetCookieValue(str)).toList());
      }

      return _handleResponse(response);
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

      final options = Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': cookiesString,
        ...headers ?? {}
      });

      final response = await _dio.get(
        endpoint,
        options: options,
      );

      return _handleResponse(response);
    } catch (e) {
      if (kDebugMode) {
        print('Exception while fetching data: $e');
      }

      rethrow;
    }
  }

  Future<dynamic> _handleResponse(Response response) async {
    if (response.statusCode == 200) {
      return response;
    } else if (response.statusCode == 401) {
      // Redirect to login screen on 401
      navigatorKey.currentState
          ?.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } else {
      throw Exception(
          'Failed to handle response. Status code: ${response.statusCode}');
    }
  }
}

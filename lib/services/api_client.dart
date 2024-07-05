import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_foundation/shared_preferences_foundation.dart';

class ApiClient {
  late Dio _dio;
  late PersistCookieJar _cookieJar;

  ApiClient(String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
    _initCookieJar();
  }

  void _initCookieJar() async {
    if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
    if (Platform.isIOS) SharedPreferencesFoundation.registerWith();

    final appDocDir = await getApplicationDocumentsDirectory();
    final cookiePath = '${appDocDir.path}/.cookies';

    _cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));
  }

  Future<dynamic> sendData(String endpoint, dynamic data,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );
      final cookies = response.headers.map['set-cookie'];

      if (cookies != null && endpoint == '/auth/login') {
        await _cookieJar.saveFromResponse(Uri.parse('https://sokker.org'),
            cookies.map((str) => Cookie.fromSetCookieValue(str)).toList());
      }

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception(
            'Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception while sending data: $e');
      }
      rethrow;
    }
  }

  Future<dynamic> fetchData(String endpoint,
      {Map<String, String>? headers}) async {
    try {
      final cookies =
          await _cookieJar.loadForRequest(Uri.parse(_dio.options.baseUrl));
      print('Cookies after login: $cookies');

      String cookiesString = cookies
          .where((cookie) =>
              cookie.name == 'PHPSESSID' ||
              cookie.name == '_html_rtl' ||
              cookie.name == 'lang' ||
              cookie.name == 'lang_ID')
          .map((cookie) => '${cookie.name}=${cookie.value}')
          .join('; ');

      final options = Options(headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cookie': cookiesString,
        ...headers ?? {}
      });

      print('Cookies in Options: ${options.headers}');

      final response = await _dio.get(
        endpoint,
        options: options,
      );

      print('fetchData Response: $response');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching current data: $e');

      rethrow;
    }
  }
}

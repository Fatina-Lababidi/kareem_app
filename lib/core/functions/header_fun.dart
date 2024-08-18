import 'package:careem_app_clean/config/dependency_injection.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

getHeader(bool userToken) {
  if (userToken) {
    return Options(headers: {
      'Authorization': 'Bearer ${config.get<SharedPreferences>().getString(
            'token',
          )}',
      "contentType": "application/json",
    });
  } else {
    return Options(headers: {
      "contentType": "application/json",
    });
  }
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt config = GetIt.instance;

init() async {
  final prefs = await SharedPreferences.getInstance();
  config.registerSingleton(prefs);
}

Future<SharedPreferences> getSharedPreferences() async {
  return await SharedPreferences.getInstance();
}

Dio createDio() {
  return Dio();
}

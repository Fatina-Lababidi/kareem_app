import 'package:careem_app/core/resources/url.dart';
import 'package:dio/dio.dart';

abstract class BaseService {
  Dio dio =Dio();
 final String baseUrl =EndPoint.baseUrl ;//! i don't now how to take it from postman
}
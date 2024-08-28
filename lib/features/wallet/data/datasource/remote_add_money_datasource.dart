import 'dart:developer';
import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:dio/dio.dart';

class RemoteAddMoneyDatasource {
  final Dio dio;
  RemoteAddMoneyDatasource({
    required this.dio,
  });

  Future<String> addMoney(String code) async {
    try {
      Response response = await dio.put(EndPoint.addMoney,
          options: getHeader(true).copyWith(validateStatus: (int? status) {
            return status != null && status < 500;
          }),
          data: {
            "code": code,
          });
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 202) {
        String message = response.data['message'];
        return message;
      } else {
        ErrorModel errorModel =
            ErrorModel(errorMessage: response.data['message']);
        throw ServerException(errorModel: errorModel);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        log("DioError caught: ${e.message}");
        final response = e.response;
        final errorData = response!.data;
        ErrorModel errorModel = ErrorModel.fromJson(errorData);
        throw ServerException(errorModel: errorModel);
      } else if (e is ServerException) {
        log("ServerException caught: ${e.errorModel.errorMessage}");
        throw ServerException(errorModel: e.errorModel);
      } else {
        log("Unknown exception caught: $e");
        throw ServerException(
          errorModel: ErrorModel(
            errorMessage: 'Please try later ...',
          ),
        );
      }
    }
  }
}

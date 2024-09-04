// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:dio/dio.dart';

class RemoteDeleteFavDatasource {
  final Dio dio;
  RemoteDeleteFavDatasource({
    required this.dio,
  });

  Future<String> deleteFavBike(int favId) async {
    try {
      String url = EndPoint.deleteFavouriteBike(favId);
      Response response = await dio.delete(url, options: getHeader(true));
      print(response.statusCode);
      print(response.data);

      if (response.statusCode == 200) {
        String message = response.data['message'];
        return message;
      } else {
        final errorData = response.data;
        ErrorModel errorModel = ErrorModel.fromJson(errorData);
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

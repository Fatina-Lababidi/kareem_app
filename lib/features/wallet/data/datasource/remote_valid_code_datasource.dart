// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/wallet/data/models/vaild_code_model.dart';
import 'package:dio/dio.dart';

class RemoteValidCodeDatasource {
  final Dio dio;
  RemoteValidCodeDatasource({
    required this.dio,
  });

  Future<ValidCodeModel> getValidCode() async {
    try {
      Response response = await dio.get(
        EndPoint.allCode,
        options: getHeader(true).copyWith(validateStatus: (int? status) {
          return status != null && status < 500;
        }),
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        ValidCodeModel validCodeModel = ValidCodeModel.fromJson(response.data);
        return validCodeModel;
      } else {
        // ErrorModel errorModel = ErrorModel(errorMessage: response.data['message']);
        throw ServerException(errorModel: ErrorModel(errorMessage: 'any'));
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

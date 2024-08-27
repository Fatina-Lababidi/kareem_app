import 'dart:developer';

import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/favourite/data/models/add_fav_response_model.dart';
import 'package:dio/dio.dart';

class RemoteGetfavbyclientidDatasource {
  final Dio dio;
  RemoteGetfavbyclientidDatasource({
    required this.dio,
  });

  Future<List<AddFavBodyResponseModel>> getFavByClientId() async {
    try {
      String url = EndPoint.getFavouriteBikesForClient;
      Response response = await dio.get(url,
          options: getHeader(true).copyWith(validateStatus: (int? status) {
            return status != null && status < 500;
          }));
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data);
        List<dynamic> bodyList = response.data['body'];
        List<AddFavBodyResponseModel> favList = bodyList
            .map((item) => AddFavBodyResponseModel.fromJson(item))
            .toList();
        return favList;
      } else if (response.statusCode == 403) {
        throw ServerException(
            errorModel: ErrorModel(errorMessage: 'forbiddeen'));
      } else {
        final errorData = response.data;
        ErrorModel errorModel = ErrorModel.fromJson(errorData);
        print('here');
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

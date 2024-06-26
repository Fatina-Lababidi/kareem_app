import 'dart:io';
import 'package:careem_app/core/functions/header_fun.dart';
import 'package:careem_app/core/resources/api_keys.dart';
import 'package:careem_app/core/resources/url.dart';
import 'package:careem_app/models/response/categories_model.dart';
import 'package:careem_app/models/result_handling_model.dart';
import 'package:careem_app/service/real/base_service.dart';
import 'package:dio/dio.dart';

class BicycleCategoriesService extends BaseService {
  Future<ResultModel> getBycicleCategories() async {
    String url = baseUrl + EndPoint.bicycleCategories;
    try {
      Response response = await dio.get(url, options: getHeader(false));
      if (response.statusCode == 200) {
        String message = response.data[ApiKey.message];
        List<String> data = List<String>.from(response.data[ApiKey.body]);//!
        String status = response.data[ApiKey.status];
        return SuccessModel<CategoriesResponseModel>(
          data: CategoriesResponseModel(
              message: message, status: status, body: data),
        );
      } else {
        return ErrorModel(message: 'error ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.error is SocketException ||
          e.message!.contains('SocketException')) {
        return OfflineModel(message: "no internet !");
      } else {
        return ExceptionModel(message: e.message.toString());
      }
    }
  }
}

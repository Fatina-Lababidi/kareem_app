import 'dart:io';
import 'package:careem_app/core/functions/header_fun.dart';
import 'package:careem_app/core/resources/url.dart';
import 'package:careem_app/models/response/bicycle_by_category_model.dart';
import 'package:careem_app/models/result_handling_model.dart';
import 'package:careem_app/service/real/base_service.dart';
import 'package:dio/dio.dart';

class BycicleByCategoryService extends BaseService {
  Future<ResultModel> getBicyclesByCategory({
    required double latitude,
    required double longitude,
    required String category,
  }) async {
    String url = baseUrl + EndPoint.bicycleByCategory;
    Map<String, dynamic> queryParams = {
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
    };

    try {
      Response response = await dio.get(
        url,
        queryParameters: queryParams,
        options: getHeader(false),
      );
      if (response.statusCode == 200) {
        BicycleResponseModel data = BicycleResponseModel.fromMap(response.data);//!! from json or from map ?
        return SuccessModel<BicycleResponseModel>(data: data);
      } else {
        return ErrorModel(message: 'Error ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.error is SocketException ||
          e.message!.contains('SocketException')) {
        return OfflineModel(message: "No internet connection !");
      } else {
        return ExceptionModel(message: e.message.toString());
      }
    }
  }
}

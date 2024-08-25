// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/bicycles/data/models/bicycle_by_category_model.dart';
import 'package:dio/dio.dart';

class RemoteBicycleByCategoryDatasource {
  final Dio dio;
  RemoteBicycleByCategoryDatasource({
    required this.dio,
  });

  Future<BicycleByCategoryModel> getBicycleByCategor(String category) async {
    try {
      String url = EndPoint.bicyclesByCategoryUrl(category);
      Response response = await dio.get(url, options: getHeader(true));
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        final data = response.data;

        BicycleByCategoryModel bicycleByCategoryModel =
            BicycleByCategoryModel.fromJson(data);

        return bicycleByCategoryModel;
      } else {
        final errorData = response.data;
        ErrorModel errorModel = ErrorModel.fromJson(errorData);
        throw ServerException(errorModel: errorModel);
      }
    } catch (e) {
      throw ServerException(
        errorModel:
            ErrorModel( errorMessage: 'please try later ...'),
      );
    }
  }
}

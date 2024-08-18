// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/bicycles/data/models/categories_model.dart';
import 'package:dio/dio.dart';

class RemoteCategoriesDatasource {
  final Dio dio;
  RemoteCategoriesDatasource({
    required this.dio,
  });

  Future<CategoriesModel> getCategories() async {
    try {
      Response response =
          await dio.get(EndPoint.bicycleCategories, options: getHeader(true));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.data);
        final data = response.data;
        CategoriesModel categoriesModel = CategoriesModel(
          message: data['message'],
          status: data['status'],
          body: List<String>.from(data['body'] as List<dynamic>),
        );
        return categoriesModel;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}

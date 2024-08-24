// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/hub/data/models/all_hub_model.dart';
import 'package:dio/dio.dart';

class RemoteAllHubDataSource {
  final Dio dio;
  RemoteAllHubDataSource({
    required this.dio,
  });

  Future<AllHubModel> getAllHub(num latitude, num longitude) async {
    try {
      String url = EndPoint.getAllHubsUrl(latitude, longitude);
      print(url);
      Response response = await dio.get(url, options: getHeader(true));
      print(response.statusCode);
      if (response.statusCode == 200) {
        AllHubModel allHubModel = AllHubModel.formJson(response.data);
        print(response.data);
        return allHubModel;
      } else {
        final errorData = response.data;
        ErrorModel errorModel = ErrorModel.fromJson(errorData);
        throw ServerException(errorModel: errorModel);
      }
    } catch (e) {
      throw ServerException(
        errorModel: ErrorModel(
          status: '',
          errorMessage: 'please try later...',
        ),
      );
    }
  }
}

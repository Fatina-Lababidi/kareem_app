// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/bicycles/data/models/bicycle_by_id_model.dart';
import 'package:dio/dio.dart';

class RemoteBicycleByIdDatasource {
  final Dio dio;
  RemoteBicycleByIdDatasource({
    required this.dio,
  });

  Future<BicycleByIdModel> getBicycleById(int id) async {
    try {
      String url = EndPoint.bicycleByIdUrl(id);
      Response response = await dio.get(url, options: getHeader(true));
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        BicycleByIdModel bicycleByIdModel =
            BicycleByIdModel.formJson(response.data);
        return bicycleByIdModel;
      } else {
        ErrorModel errorModel =
            ErrorModel.fromJson(response.data); //just the message
        throw ServerException(errorModel: errorModel);
      }
    } catch (e) {
      throw ServerException(
        errorModel: ErrorModel(errorMessage: 'please try later ...'),
      );
    }
  }
}

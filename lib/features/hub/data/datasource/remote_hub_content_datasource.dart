import 'dart:developer';
import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/hub/data/models/hub_content_model.dart';
import 'package:dio/dio.dart';

class RemoteHubContentDatasource {
  final Dio dio;
  RemoteHubContentDatasource({
    required this.dio,
  });

  Future<HubContentResponseModel> getHubContent(
      int hubId, String category) async {
    try {
      String url = EndPoint.gethubContentUrl(hubId, category);
      print(url);
      Response response = await dio.get(
        url,
        options: getHeader(true).copyWith(validateStatus: (int? status) {
          return status != null && status < 500;
        }),
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        HubContentResponseModel hubContentResponseModel =
            HubContentResponseModel.fromJson(response.data);
        return hubContentResponseModel;
      } else {
        ErrorModel errorModel = ErrorModel.fromJson(response.data);
        throw ServerException(errorModel: errorModel);
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(
        errorModel: ErrorModel(
          errorMessage: 'Unhandled Dio exception occurred',
        ),
      );
    } catch (e) {
      if (e is ServerException) {
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

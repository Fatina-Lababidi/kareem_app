import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/favourite/data/models/add_fav_response_model.dart';
import 'package:dio/dio.dart';

class RemoteAddFavDatasource {
  final Dio dio;
  RemoteAddFavDatasource({
    required this.dio,
  });

  Future<AddFavBodyResponseModel> addFav(int bicycleId) async {
    try {
      Response response = await dio
          .post(EndPoint.addFavouriteUrl, options: getHeader(true), data: {
        "bicycleId": bicycleId,
      });
      print(response.statusCode);
      if (response.statusCode == 201) {
        print(response.data);
        print('any any');
        AddFavBodyResponseModel addFavResponseModel =
            AddFavBodyResponseModel.fromJson(response.data['body']);
        // log(addFavResponseModel.client.id.toString());
        print(addFavResponseModel);
        print('any any');
        return addFavResponseModel;
      } else {
        final errorData = response.data;
        ErrorModel errorModel = ErrorModel.fromJson(errorData);
        throw ServerException(errorModel: errorModel);
      }
    } catch (e) {
      throw ServerException(
        errorModel: ErrorModel(
          status: '',
          errorMessage: 'please try later ...',
        ),
      );
    }
  }
}

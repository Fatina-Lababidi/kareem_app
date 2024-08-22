// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  Future<List<AddFavBodyResponseModel>> getFavByClientId(int clientId) async {
    // try {
    String url = EndPoint.getFavouritebyClientId(clientId);
    Response response = await dio.get(url, options: getHeader(true));
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.data);
        List<dynamic> bodyList = response.data['body'];
      List<AddFavBodyResponseModel> favList = bodyList.map((item) => AddFavBodyResponseModel.fromJson(item)).toList();

      return favList;
    } else {
      throw ServerException();
    }
    // } catch (e) {
    //   throw ServerException();
    // }
  }
}

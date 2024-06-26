import 'dart:io';

import 'package:careem_app/core/config/dependency_injection.dart';
import 'package:careem_app/core/functions/header_fun.dart';
import 'package:careem_app/core/resources/api_keys.dart';
import 'package:careem_app/core/resources/url.dart';
import 'package:careem_app/models/request/register_model.dart';
import 'package:careem_app/models/response/register_response_model.dart';
import 'package:careem_app/models/result_handling_model.dart';
import 'package:careem_app/service/real/base_service.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterService extends BaseService {
  Future<ResultModel> register(RegisterModel user) async {
    try {
      String url = baseUrl +
          EndPoint.registerUrl; //!here we can make it from the url not here?
      Response response =
          await dio.post(url, data: user.toMap(), options: getHeader(false));
      if (response.data == 200) {
        String message = response.data[ApiKey.message];
        String token = response.data[ApiKey.body][ApiKey.token];
        config.get<SharedPreferences>().setString('token', token);
        return SuccessModel<RegisterResponseModel>(
            data:
                RegisterResponseModel(message: message, token: token)); //! here
      } else {
        return ErrorModel(message: "not 200:${response.statusCode}");
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

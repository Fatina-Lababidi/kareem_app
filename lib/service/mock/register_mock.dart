import 'dart:io';

import 'package:careem_app/models/request/register_model.dart';
import 'package:careem_app/models/response/register_response_model.dart';
import 'package:careem_app/models/result_handling_model.dart';
import 'package:careem_app/service/real/register_service.dart';
import 'package:mockito/mockito.dart';

class MockRegisterService extends Mock implements RegisterService {
  @override
  Future<ResultModel> register(RegisterModel user) async {
    await Future.delayed(const Duration(seconds: 2));
    print(user);
    try {
      if (user.firstName.isNotEmpty &&
          user.lastName.isNotEmpty &&
          user.phone.isNotEmpty &&
          user.username.isNotEmpty &&
          user.birthDate.isNotEmpty &&
          user.password.isNotEmpty &&
          user.confirmPassword.isNotEmpty) {
        return SuccessModel<RegisterResponseModel>(
            data: RegisterResponseModel(
                message: "success fack register", token: "fake token here!!"));
      } else {
        return ErrorModel(
            message:
                'fake error , it will never be empty because we cack this in the ui');
      }
    } catch (e) {
      if (e is SocketException) {
        return OfflineModel(message: "no internet !");
      } else {
        return ExceptionModel(message: e.toString());
      }
    }
  }
}

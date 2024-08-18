import 'dart:developer';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/authentication/data/models/register_model.dart';
import 'package:dio/dio.dart';

abstract class RemoteUserDataSource {
  Future<String> registerUser(UserModel userModel);
  Future<String> loginUser(String phone, String password);
  Future<String> changePassword(
      String currentPassword, String newPassword, String confirmPassword);
}

class RemoteUserDataSourceImpl implements RemoteUserDataSource {
  final Dio dio;
  RemoteUserDataSourceImpl({required this.dio});
  @override
  Future<String> registerUser(UserModel userModel) async {
    log("Attempting to register user with data: ${userModel.toJson()}");
    print("Sending request to URL: ${EndPoint.registerUrl}");
    try {
      final response = await dio.post(
        EndPoint.registerUrl,
        data: userModel.toJson(),
        options: getHeader(false),
      );
      log("Response received with status code: ${response.statusCode}");
      log("Response data: ${response.data}");

      if (response.statusCode == 200) {
        log("Registration successful, token: ${response.data['body']['token']}");
        return response.data['body']['token'];
      } else {
        log("Unexpected status code: ${response.statusCode}");
        throw ServerException();
      }
    } catch (e) {
      log("Exception caught: $e");
      throw ServerException();
    }
  }

  @override
  Future<String> loginUser(String phone, String password) async {
    final response = await dio.post(EndPoint.loginUrl,
        data: {'phone': phone, 'password': password},
        options: getHeader(false));
    if (response.statusCode == 200) {
      log('log in done');
      // ? save the token: here ? or in the other place ?

      return response.data['body']['token'];
    } else {
      log("Unexpected status code: ${response.statusCode}");
      throw ServerException();
    }
  }

  @override
  Future<String> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    final response = await dio.put(
      EndPoint.changePassword,
      data: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      },
      options: getHeader(true),
    );
    if (response.statusCode == 202) {
      log('change password done! ');
      return response.data;
    } else {
      log("Unexpected status code: ${response.statusCode}");
      throw ServerException();
    }
  }
}

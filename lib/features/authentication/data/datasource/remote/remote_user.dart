import 'dart:developer';
import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/authentication/data/models/login_response_model.dart';
import 'package:careem_app_clean/features/authentication/data/models/register_model.dart';
import 'package:careem_app_clean/features/authentication/domain/entities/login_response_entity.dart';
import 'package:dio/dio.dart';

abstract class RemoteUserDataSource {
  Future<String> registerUser(UserModel userModel);
  Future<LoginResponseEntity> loginUser(String phone, String password);
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
        options: getHeader(false).copyWith(
          validateStatus: (int? status) {
            return status != null && status < 500;
          },
        ),
      );

      log("Response received with status code: ${response.statusCode}");
      log("Response data: ${response.data}");

      if (response.statusCode == 200) {
        log("Registration successful, token: ${response.data['body']['token']}");
        return response.data['body']['token'];
      } else {
        final errorData = response.data;
        final errorMessage = errorData['message'] is String
            ? errorData['message']
            : (errorData['message'] as List<dynamic>?)?.join(', ') ??
                'Unknown error occurred';

        log("Error during registration: $errorMessage");
        throw ServerException(
          errorModel: ErrorModel(errorMessage: errorMessage),
        );
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        log("DioException caught: ${e.message}");
        final response = e.response;
        final errorData = response!.data;
        final errorMessage = errorData['message'] is String
            ? errorData['message']
            : (errorData['message'] as List<dynamic>?)?.join(', ') ??
                'Unknown error occurred';

        log("DioException extracted message: $errorMessage");
        throw ServerException(
          errorModel: ErrorModel(errorMessage: errorMessage),
        );
      } else if (e is ServerException) {
        log("ServerException caught with message: ${e.errorModel.errorMessage}");
        throw e;
      } else {
        log("Unknown exception caught: $e");
        throw ServerException(
          errorModel: ErrorModel(
            errorMessage: 'Unexpected error occurred',
          ),
        );
      }
    }
  }

  @override
  Future<LoginResponseEntity> loginUser(String phone, String password) async {
    try {
      final response = await dio.post(EndPoint.loginUrl,
          data: {'phone': phone, 'password': password},
          options: getHeader(false).copyWith(validateStatus: (int? status) {
            return status != null && status < 500;
          }));
      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        log('log in done');
        print(response.data['body']['id']);
        // ? save the token: here ? or in the other place ?
        //    return response.data['body']['token'];
        LoginResponseModel loginResponseEntity = LoginResponseModel(
            token: response.data['body']['token'],
            id: response.data['body']['id']);
        return loginResponseEntity;
      } else {
        log("Unexpected status code: ${response.statusCode}");
        final errorData = response.data;
        final errorMessage = errorData['message'] is String
            ? errorData['message']
            : (errorData['message'] as List<dynamic>?)?.join(', ') ??
                'An unexpected error occurred.';

        log("Error message from server: $errorMessage");
        throw ServerException(
          errorModel: ErrorModel(errorMessage: errorMessage),
        );
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        log("DioException caught: ${e.message}");
        final response = e.response;
        final errorData = response!.data;
        final errorMessage = errorData['message'] is String
            ? errorData['message']
            : (errorData['message'] as List<dynamic>?)?.join(', ') ??
                'An unexpected error occurred.';

        log("DioException extracted message: $errorMessage");
        throw ServerException(
          errorModel: ErrorModel(errorMessage: errorMessage),
        );
      } else if (e is ServerException) {
        log("ServerException caught with message: ${e.errorModel.errorMessage}");
        throw e;
      } else {
        log("Unknown exception caught: $e");
        throw ServerException(
          errorModel: ErrorModel(
            errorMessage: 'Please try later...',
          ),
        );
      }
    }
  }

  @override
  Future<String> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    try {
      final response = await dio.put(
        EndPoint.changePassword,
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmPassword": confirmPassword,
        },
        options: getHeader(true).copyWith(validateStatus: (int? status) {
          return status != null && status < 500;
        }),
      );
      if (response.statusCode == 202) {
        log('change password done! ');
        return response.data;
      } else {
        log("Unexpected status code: ${response.statusCode}");
        final errorData = response.data;
        ErrorModel errorModel = ErrorModel.fromJson(errorData);
        throw ServerException(errorModel: errorModel);
      }
    } catch (e) {
      log("Exception caught: $e");
      throw ServerException(
        errorModel: ErrorModel(
          errorMessage: 'Unexpected error occurred',
        ),
      );
    }
  }
}

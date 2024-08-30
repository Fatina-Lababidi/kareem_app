// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:dio/dio.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException({
    required this.errorModel,
  });
  // @override
  // String toString() {
  //   return 'ServerExeption:${errorModel.errorMessage}';
  // }
}

class OfflineException implements Exception {}

class EmptyCacheException implements Exception {}

class CacheException implements Exception {}

void handleDioExceptions(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.sendTimeout:
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.receiveTimeout:
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.badCertificate:
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.cancel:
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.connectionError:
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.unknown:
      throw ServerException(errorModel: ErrorModel.fromJson(e.response!.data));
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 401: //unauthorized
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 403: //forbidden
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 404: //not found
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 409: //cofficient
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 422: //  Unprocessable Entity
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        case 504: // Server exception
          throw ServerException(
              errorModel: ErrorModel.fromJson(e.response!.data));
        default:
          throw ServerException(
              errorModel: ErrorModel(
                  errorMessage:
                      'unhandled response status code:${e.response?.statusCode}'));
      }
    default:
      throw ServerException(
          errorModel: ErrorModel(
              errorMessage: 'Unhandled DioException type: ${e.type}'));
  }
}

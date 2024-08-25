// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:careem_app_clean/core/error/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException({
    required this.errorModel,
  });
  @override
  String toString() {
    return 'ServerExeption:${errorModel.errorMessage}';
  }
}

class OfflineException implements Exception {}

class EmptyCacheException implements Exception {}

class CacheException implements Exception {}

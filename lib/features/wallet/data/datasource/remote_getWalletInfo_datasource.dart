import 'dart:developer';

import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/wallet/data/models/wallet_info_model.dart';
import 'package:dio/dio.dart';

class RemoteGetwalletinfoDatasource {
  final Dio dio;
  RemoteGetwalletinfoDatasource({
    required this.dio,
  });

  Future<WalletInfoModel> getMyWalletInfo() async {
    try {
      Response response =
          await dio.get(EndPoint.getMyWalletInfo, options: getHeader(true));
      print(response.statusCode);
      print(response.data);

      if (response.statusCode == 200) {
        WalletInfoModel walletInfoModel =
            WalletInfoModel.fromJson(response.data);
        print(walletInfoModel);
        return walletInfoModel;
      } else if (response.statusCode == 403) {
        throw ServerException(
            errorModel: ErrorModel(errorMessage: 'forbiddeen'));
      }
       else {
        ErrorModel errorModel = ErrorModel.fromJson(response.data);
        throw ServerException(errorModel: errorModel);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        log("DioError caught: ${e.message}");
        final response = e.response;
        final errorData = response!.data;
        ErrorModel errorModel = ErrorModel.fromJson(errorData);
        throw ServerException(errorModel: errorModel);
      } else if (e is ServerException) {
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

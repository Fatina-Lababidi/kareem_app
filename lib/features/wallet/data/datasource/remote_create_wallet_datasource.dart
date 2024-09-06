// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/wallet/data/models/create_wallet_model.dart';
import 'package:dio/dio.dart';

class RemoteCreateWalletDatasource {
  final Dio dio;
  RemoteCreateWalletDatasource({
    required this.dio,
  });

  Future<String> createWallet(CreateWalletModel model) async {
    try {
      Response response = await dio.post(
        EndPoint.createNewWallet,
        data: model.toJson(),
        options: getHeader(true).copyWith(validateStatus: (int? status) {
          return status != null && status < 500;
        }),
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 201) {
        print('create new wallet done');
        String message = response.data['message'];
        return message;
      } else {
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
// response data : {
//   "message": "Wallet Added Successfully",
//   "status": "CREATED",
//   "localDateTime": "2024-08-27T10:39:24.7222906",
//   "body": {
//     "id": 168,
//     "balance": 0,
//     "bankAccount": "create wallet"
//   }
// }
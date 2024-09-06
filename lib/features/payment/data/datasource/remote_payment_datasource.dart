// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/payment/data/models/payment_model.dart';
import 'package:dio/dio.dart';

// [log] Unexpected status code: 401
// [log] Unknown exception caught: type 'String' is not a subtype of type 'Map<dynamic, dynamic>'

class RemotePaymentDatasource {
  final Dio dio;
  RemotePaymentDatasource({
    required this.dio,
  });

  Future<String> pay(PaymentRequestModel payment) async {
    try {
      Response response = await dio.post(
        EndPoint.reservationPayment,
        data: payment.toJson(),
        options: getHeader(true).copyWith(validateStatus: (int? status) {
          return status != null && status < 500;
        }),
      );
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        print(response.data['message']);
        return response.data['message'];
      } else {
        log("Unexpected status code: ${response.statusCode}");
        if (response.data is Map) {
          final errorData = response.data['message'];
          ErrorModel errorModel = ErrorModel(errorMessage: errorData);
          throw ServerException(errorModel: errorModel);
        } else {
          ErrorModel errorModel = ErrorModel(
              errorMessage: 'Unexpected error format : ${response.data}');
          throw ServerException(errorModel: errorModel);
        }
      }
    } on DioException catch (e) {
      handleDioExceptions(e);
      throw ServerException(
        errorModel: ErrorModel(
          errorMessage: 'Unhandled Dio exception occurred',
        ),
      );
    } catch (e) {
      if (e is ServerException) {
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

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/hub/data/models/reservation_models.dart';
import 'package:dio/dio.dart';

class RemoteReservationDatasource {
  final Dio dio;
  RemoteReservationDatasource({
    required this.dio,
  });

  Future<ReservationResponseModel> makeReservation(
      ReservationRequestModel reservation) async {
    try {
      print("reservation to Json:  ${reservation.toJson()}");
      Response response = await dio.post(
        EndPoint.makeReservationUrl,
        data: reservation.toJson(),
        options: getHeader(true).copyWith(
          validateStatus: (int? status) {
            return status != null && status < 500;
          },
        ),
      );
      print(response.statusCode);
      print("response data : ${response.data}");
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['status'] == 'CREATED') {
          ReservationResponseModel responseModel =
              ReservationResponseModel.fromJson(response.data);
          return responseModel;
        } else if (response.data['status'] == 'BAD_REQUEST') {
          print('Reservation failed: ${response.data['message']}');
          ErrorModel errorModel = ErrorModel.fromJson(response.data['message']);
          throw ServerException(errorModel: errorModel);
        } else {
          ErrorModel errorModel = ErrorModel.fromJson(response.data['message']);
          throw ServerException(errorModel: errorModel);
        }
      } else if (response.data != null && response.data['message'] != null) {
        ErrorModel errorModel = ErrorModel.fromJson(response.data['message']);
        throw ServerException(errorModel: errorModel);
      } else {
        throw ServerException(
            errorModel: ErrorModel(errorMessage: 'unknown error'));
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

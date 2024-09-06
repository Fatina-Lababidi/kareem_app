// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:careem_app_clean/core/error/error_model.dart';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/functions/header_fun.dart';
import 'package:careem_app_clean/core/resources/url.dart';
import 'package:careem_app_clean/features/hub/data/models/reservation_details_model.dart';
import 'package:dio/dio.dart';

class RemoteReservationDetailsDatasource {
  final Dio dio;
  RemoteReservationDetailsDatasource({
    required this.dio,
  });

  Future<ReservationDetailsResponseModel> getReservationDetails(
      int clientId) async {
    try {
      String url = EndPoint.getReservationDetailsByClientId(clientId);

      Response response = await dio.get(url,
          options: getHeader(true).copyWith(validateStatus: (int? status) {
            return status != null && status < 500;
          }));
      print(response.statusCode);
      if (response.statusCode == 200) {
        ReservationDetailsResponseModel reservationDetailsResponseModel =
            ReservationDetailsResponseModel.fromJson(response.data);
        return reservationDetailsResponseModel;
      } else {
        throw ServerException(
            errorModel: ErrorModel.fromJson(response.data['message']));
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

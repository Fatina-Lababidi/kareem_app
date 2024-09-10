import 'dart:developer';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_hub_content_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_datasource.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_reservation_details_datasource.dart';
import 'package:careem_app_clean/features/hub/data/models/all_hub_model.dart';
import 'package:careem_app_clean/features/hub/data/models/hub_content_model.dart';
import 'package:careem_app_clean/features/hub/data/models/reservation_models.dart';
import 'package:careem_app_clean/features/hub/domain/entities/all_hub_entity.dart';
import 'package:careem_app_clean/features/hub/domain/entities/hub_content_entity.dart';
import 'package:careem_app_clean/features/hub/domain/entities/reservation_details_entity.dart';
import 'package:careem_app_clean/features/hub/domain/entities/reservation_entity.dart';
import 'package:careem_app_clean/features/hub/domain/repositories/hub_repo.dart';
import 'package:dartz/dartz.dart';

class AllHubRepoImp implements HubRepo {
  final RemoteAllHubDataSource remoteAllHubDataSource;
  final RemoteHubContentDatasource remoteHubContentDatasource;
  final RemoteReservationDatasource remoteReservationDatasource;
  final RemoteReservationDetailsDatasource remoteReservationDetailsDatasource;
  final NetworkConnection networkConnection;

  AllHubRepoImp({
    required this.remoteAllHubDataSource,
    required this.networkConnection,
    required this.remoteReservationDatasource,
    required this.remoteHubContentDatasource,
    required this.remoteReservationDetailsDatasource,
  });

  @override
  Future<Either<Failures, AllHubEntity>> getAllHub(
      num latitude, num longitude) async {
    if (await networkConnection.isConnected) {
      try {
        AllHubModel allHubModel =
            await remoteAllHubDataSource.getAllHub(latitude, longitude);
        return Right(allHubModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, HubContentResponseEntity>> getHubContent(
      int hubId, String category) async {
    if (await networkConnection.isConnected) {
      try {
        HubContentResponseModel hubContent =
            await remoteHubContentDatasource.getHubContent(hubId, category);
        return Right(hubContent);
      } on ServerException catch (e) {
        log(e.errorModel.errorMessage);
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      log('no internet');
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, ReservationResponseEntity>> makeReservation(
      ReservationRequestEntity reservation) async {
    if (await networkConnection.isConnected) {
      try {
        log('AllHubRepoImp - Making reservation: $reservation');
        ReservationRequestModel reservationRequestModel =
            ReservationRequestModel.fromEntity(reservation);

        ReservationResponseEntity reservationResponseModel =
            await remoteReservationDatasource
                .makeReservation(reservationRequestModel);
        log('AllHubRepoImp - Received response: $reservationResponseModel');
        return Right(reservationResponseModel);
      } on ServerException catch (e) {
        log(e.errorModel.errorMessage);
        log('AllHubRepoImp - Error in makeReservation: $e');
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, ReservationDetailsResponseEntity>>
      getReservationDetails(int clientId) async {
    if (await networkConnection.isConnected) {
      try {
        ReservationDetailsResponseEntity reservationDetailsResponseEntity =
            await remoteReservationDetailsDatasource
                .getReservationDetails(clientId);
        return Right(reservationDetailsResponseEntity);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/features/hub/data/datasource/remote_all_hub.dart';
import 'package:careem_app_clean/features/hub/data/models/all_hub_model.dart';
import 'package:careem_app_clean/features/hub/domain/entities/all_hub_entity.dart';
import 'package:careem_app_clean/features/hub/domain/repositories/hub_repo.dart';
import 'package:dartz/dartz.dart';

class AllHubRepoImp implements HubRepo {
  final RemoteAllHubDataSource remoteAllHubDataSource;
  final NetworkConnection networkConnection;

  AllHubRepoImp(
      {required this.remoteAllHubDataSource, required this.networkConnection});

  @override
  Future<Either<Failures, AllHubEntity>> getAllHub(
      num latitude, num longitude) async {
    if (await networkConnection.isConnected) {
      try {
        AllHubModel allHubModel =
            await remoteAllHubDataSource.getAllHub(latitude, longitude);
        return Right(allHubModel);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

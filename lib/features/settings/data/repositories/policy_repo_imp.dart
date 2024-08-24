import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/features/settings/data/datasource/remote_policy.dart';
import 'package:careem_app_clean/features/settings/data/models/policy_model.dart';
import 'package:careem_app_clean/features/settings/domain/entities/policy_entity.dart';
import 'package:careem_app_clean/features/settings/domain/repositories/policy_reop.dart';
import 'package:dartz/dartz.dart';

class PolicyRepoImp implements PolicyRepo {
  RemotePolicyDataSource remotePolicyDataSource;
  NetworkConnection networkConnection;
  PolicyRepoImp({
    required this.remotePolicyDataSource,
    required this.networkConnection,
  });

  @override
  Future<Either<Failures, PolicyEntity>> getPolicy() async {
    print(await networkConnection.isConnected);
    if (await networkConnection.isConnected) {
      try {
        PolicyModel policy = await remotePolicyDataSource.getPolicy();
        return Right(policy);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

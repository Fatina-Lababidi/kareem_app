// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_add_fav_datasource.dart';
import 'package:careem_app_clean/features/favourite/data/datasource/remote_getFavByClientId_datasource.dart';
import 'package:careem_app_clean/features/favourite/domain/entities/add_fav_response_entity.dart';
import 'package:careem_app_clean/features/favourite/domain/repositories/favourite_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFavRepoImp implements FavouriteRepo {
  RemoteAddFavDatasource remoteAddFavDatasource;
  RemoteGetfavbyclientidDatasource remoteGetfavbyclientidDatasource;
  SharedPreferences sharedPreferences;
  NetworkConnection networkConnection;
  AddFavRepoImp({
    required this.remoteAddFavDatasource,
    required this.sharedPreferences,
    required this.networkConnection,
    required this.remoteGetfavbyclientidDatasource,
  });

  @override
  Future<Either<Failures, AddFavResponseEntity>> addFav(int bicycleId) async {
    if (await networkConnection.isConnected) {
      try {
        AddFavResponseEntity addFavBodyResponseEntity =
            await remoteAddFavDatasource.addFav(bicycleId);
        int clientId = addFavBodyResponseEntity.client.id;
        await sharedPreferences.setInt('client_Id', clientId);

        return Right(addFavBodyResponseEntity);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, List<AddFavResponseEntity>>> getFavByClientId(
      int clientId) async {
    if (await networkConnection.isConnected) {
      print('there is internet');
      try {
        List<AddFavResponseEntity> fav =
            await remoteGetfavbyclientidDatasource.getFavByClientId(clientId);
        return Right(fav);
      } on ServerException catch(e){
        print('here');
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

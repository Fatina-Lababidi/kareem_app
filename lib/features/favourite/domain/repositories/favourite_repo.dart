import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/favourite/domain/entities/add_fav_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FavouriteRepo {
  Future<Either<Failures, AddFavResponseEntity>> addFav(int bicycleId);
  Future<Either<Failures, List<AddFavResponseEntity>>> getFavByClientId(int clientId);
}

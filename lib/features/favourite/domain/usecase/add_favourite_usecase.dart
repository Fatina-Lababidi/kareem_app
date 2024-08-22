// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/favourite/domain/entities/add_fav_response_entity.dart';
import 'package:careem_app_clean/features/favourite/domain/repositories/favourite_repo.dart';
import 'package:dartz/dartz.dart';

class AddFavouriteUsecase {
  final FavouriteRepo favouriteRepo;
  final int bicycleId;
  AddFavouriteUsecase({
    required this.favouriteRepo,
    required this.bicycleId,
  });

  Future<Either<Failures, AddFavResponseEntity>> call() async {
    return await favouriteRepo.addFav(bicycleId);
  }
}

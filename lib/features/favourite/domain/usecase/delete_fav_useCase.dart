// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/favourite/domain/repositories/favourite_repo.dart';
import 'package:dartz/dartz.dart';

class DeleteFavouriteUsecase {
  final FavouriteRepo favouriteRepo;
  // final int favId;
  DeleteFavouriteUsecase(
    {
      // required  this.favId,
    required this.favouriteRepo,
  });

  Future<Either<Failures, String>> call(int favId) async {
    return await favouriteRepo.deleteFavouriteBike(favId);
  }
}

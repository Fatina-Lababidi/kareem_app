// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/favourite/domain/entities/add_fav_response_entity.dart';
import 'package:careem_app_clean/features/favourite/domain/repositories/favourite_repo.dart';
import 'package:dartz/dartz.dart';

class GetFavByClientidUsecase {
  final FavouriteRepo favouriteRepo;
 // final int clientId;
  GetFavByClientidUsecase({
    required this.favouriteRepo,
   // required this.clientId,
  });

  Future<Either<Failures, List<AddFavResponseEntity>>> call() async {
    return await favouriteRepo.getFavByClientId();
  }
}

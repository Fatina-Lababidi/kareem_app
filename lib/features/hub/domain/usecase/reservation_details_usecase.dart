// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/hub/domain/entities/reservation_details_entity.dart';
import 'package:careem_app_clean/features/hub/domain/repositories/hub_repo.dart';
import 'package:dartz/dartz.dart';

class ReservationDetailsUsecase {
  final HubRepo hubRepo;
  ReservationDetailsUsecase({
    required this.hubRepo,
  });

  Future<Either<Failures, ReservationDetailsResponseEntity>> call(
      int clientId) async {
    return await hubRepo.getReservationDetails(clientId);
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/hub/domain/entities/all_hub_entity.dart';
import 'package:careem_app_clean/features/hub/domain/repositories/hub_repo.dart';
import 'package:dartz/dartz.dart';

class AllHubUsecase {
  final HubRepo hubRepo;
  final num latitude;
  final num longitude;
  AllHubUsecase({
    required this.hubRepo,
    required this.latitude,
    required this.longitude,
  });

  Future<Either<Failures, AllHubEntity>> call() async{
    return await hubRepo.getAllHub(latitude, longitude);
  }
}

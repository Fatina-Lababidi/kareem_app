// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/hub/domain/entities/hub_content_entity.dart';
import 'package:careem_app_clean/features/hub/domain/repositories/hub_repo.dart';
import 'package:dartz/dartz.dart';

class HubContentUsecase {
  final HubRepo hubRepo;
  final int hubId;
  final String category;
  HubContentUsecase({
    required this.hubRepo,
    required this.hubId,
    required this.category,
  });
  Future<Either<Failures, HubContentResponseEntity>> call() async {
    return await hubRepo.getHubContent(hubId, category);
  }
}

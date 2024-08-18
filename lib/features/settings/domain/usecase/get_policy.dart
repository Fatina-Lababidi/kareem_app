
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/settings/domain/entities/policy_entity.dart';
import 'package:careem_app_clean/features/settings/domain/repositories/policy_reop.dart';
import 'package:dartz/dartz.dart';

class GetPolicyUseCase {
  PolicyRepo policyRepo;
  GetPolicyUseCase({
    required this.policyRepo,
  });

  Future<Either<Failures, PolicyEntity>> call() async {
    return await policyRepo.getPolicy();
  }
}

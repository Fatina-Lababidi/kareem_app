import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/settings/domain/entities/policy_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PolicyRepo {
  Future<Either<Failures, PolicyEntity>> getPolicy();
}

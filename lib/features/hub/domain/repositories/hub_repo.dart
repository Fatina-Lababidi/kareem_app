import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/hub/domain/entities/all_hub_entity.dart';
import 'package:dartz/dartz.dart';

abstract class HubRepo {
  Future<Either<Failures, AllHubEntity>> getAllHub(num latitude, num longitude);
}

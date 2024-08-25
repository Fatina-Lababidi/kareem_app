import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_id.dart';
import 'package:careem_app_clean/features/bicycles/domain/repositories/categories_repo.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class BicycleByIdUsecase {
  final CategoriesRepo categoriesRepo;
  final int id;
  BicycleByIdUsecase({
    required this.categoriesRepo,
    required this.id,
  });

  Future<Either<Failures, BicycleByIdEntity>> call() async {
    return await categoriesRepo.getBicycleById(id);
  }
}

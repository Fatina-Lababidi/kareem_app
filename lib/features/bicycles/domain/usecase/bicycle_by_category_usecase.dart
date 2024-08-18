// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_ctegory_entity.dart';
import 'package:careem_app_clean/features/bicycles/domain/repositories/categories_repo.dart';
import 'package:dartz/dartz.dart';

class BicycleByCategoryUsecase {
  final CategoriesRepo categoriesRepo;
  final String category;
  BicycleByCategoryUsecase({
    required this.category,
    required this.categoriesRepo,
  });

  Future<Either<Failures, BicycleByCtegoryEntity>> call() async {
    return await categoriesRepo.getBicycleByCategor(category);
  }
}

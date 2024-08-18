// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/categories_entity.dart';
import 'package:careem_app_clean/features/bicycles/domain/repositories/categories_repo.dart';
import 'package:dartz/dartz.dart';

class GetCategoriesUsecase {
  CategoriesRepo categoriesRepo;
  GetCategoriesUsecase({
    required this.categoriesRepo,
  });

  Future<Either<Failures, CategoriesEntity>> call() async {
    return await categoriesRepo.getCategories();
  }
}



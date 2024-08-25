import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_ctegory_entity.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_id.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/categories_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CategoriesRepo {
  Future<Either<Failures, CategoriesEntity>> getCategories();
  Future<Either<Failures, BicycleByCtegoryEntity>> getBicycleByCategor(
      String category);
  Future<Either<Failures, BicycleByIdEntity>> getBicycleById(int id);
}

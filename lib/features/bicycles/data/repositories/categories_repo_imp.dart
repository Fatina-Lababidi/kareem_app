// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/core/network/network_connection.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_category_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_bicycle_by_id_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/datasource/remote_categories_datasource.dart';
import 'package:careem_app_clean/features/bicycles/data/models/bicycle_by_category_model.dart';
import 'package:careem_app_clean/features/bicycles/data/models/bicycle_by_id_model.dart';
import 'package:careem_app_clean/features/bicycles/data/models/categories_model.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_ctegory_entity.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_id.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/categories_entity.dart';
import 'package:careem_app_clean/features/bicycles/domain/repositories/categories_repo.dart';
import 'package:dartz/dartz.dart';

class CategoriesRepoImp implements CategoriesRepo {
  final RemoteBicycleByCategoryDatasource remoteBicycleByCategoryDatasource;
  final RemoteCategoriesDatasource remoteCategoriesDatasource;
  final RemoteBicycleByIdDatasource remoteBicycleByIdDatasource;
  final NetworkConnection networkConnection;
  CategoriesRepoImp({
    required this.remoteBicycleByCategoryDatasource,
    required this.remoteCategoriesDatasource,
    required this.remoteBicycleByIdDatasource,
    required this.networkConnection,
  });

  @override
  Future<Either<Failures, CategoriesEntity>> getCategories() async {
    if (await networkConnection.isConnected) {
      try {
        CategoriesModel categories =
            await remoteCategoriesDatasource.getCategories();
        return Right(categories);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, BicycleByCtegoryEntity>> getBicycleByCategor(
      String category) async {
    if (await networkConnection.isConnected) {
      try {
        BicycleByCategoryModel bicycleByCategoryModel =
            await remoteBicycleByCategoryDatasource
                .getBicycleByCategor(category);
        return Right(bicycleByCategoryModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, BicycleByIdEntity>> getBicycleById(int id) async {
    if (await networkConnection.isConnected) {
      try {
        BicycleByIdModel bicycleByIdModel =
            await remoteBicycleByIdDatasource.getBicycleById(id);
        return Right(bicycleByIdModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

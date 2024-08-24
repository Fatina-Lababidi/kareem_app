import 'dart:developer';
import 'package:careem_app_clean/core/error/exceptions.dart';
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/authentication/data/datasource/remote/remote_user.dart';
import 'package:careem_app_clean/features/authentication/data/models/register_model.dart';
import 'package:careem_app_clean/features/authentication/domain/entities/user_entity.dart';
import 'package:careem_app_clean/features/authentication/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteUserDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;
  final InternetConnectionChecker internetConnectionChecker;
  AuthRepositoryImpl({
    required this.internetConnectionChecker,
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failures, String>> registerUser(UserEntity user) async {
    if (await internetConnectionChecker.hasConnection) {
      try {
        final userModel = UserModel.fromEntity(user);
        final token = await remoteDataSource.registerUser(userModel);
        // Save token :
        //  config.get<SharedPreferences>().setString('token', token);
        await sharedPreferences.setString('token', token);

        return Right(token);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, String>> loginUser(
      String phone, String password) async {
    if (await internetConnectionChecker.hasConnection) {
      try {
        final token = await remoteDataSource.loginUser(phone, password);
        //? here ?

        await sharedPreferences.setString('token', token);
        print(sharedPreferences.getString('token'));
        return Right(token);
      } on ServerException catch (e) {
        log(e.toString());
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failures, String>> changePassword(String currentPassword,
      String newPassword, String confirmPassword) async {
    if (await internetConnectionChecker.hasConnection) {
      try {
        final message = await remoteDataSource.changePassword(
            currentPassword, newPassword, confirmPassword);
        return Right(message);
      } on ServerException catch (e) {
        log(e.toString());
        return Left(ServerFailure(message: e.errorModel.errorMessage));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

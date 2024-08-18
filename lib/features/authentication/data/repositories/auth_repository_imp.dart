import 'dart:developer';
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

  Future<bool> _hasConnection() async {
    return await internetConnectionChecker.hasConnection;
  }

  @override
  Future<Either<Failures, String>> registerUser(UserEntity user) async {
    if (!await _hasConnection()) {
      return Left(OfflineFailure());
    }
    try {
      final userModel = UserModel.fromEntity(user);
      final token = await remoteDataSource.registerUser(userModel);
      // Save token :
      //  config.get<SharedPreferences>().setString('token', token);
      await sharedPreferences.setString('token', token);
      return Right(token);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failures, String>> loginUser(
      String phone, String password) async {
    if (!await _hasConnection()) {
      return Left(OfflineFailure());
    }
    try {
      final token = await remoteDataSource.loginUser(phone, password);
      //? here ?

      await sharedPreferences.setString('token', token);
      return Right(token);
    } catch (e) {
      log(e.toString());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failures, String>> changePassword(String currentPassword,
      String newPassword, String confirmPassword) async {
    if (!await _hasConnection()) {
      return Left(OfflineFailure());
    }
    try {
      final message = await remoteDataSource.changePassword(
          currentPassword, newPassword, confirmPassword);
      return Right(message);
    } catch (e) {
      log(e.toString());
      return Left(ServerFailure());
    }
  }
}

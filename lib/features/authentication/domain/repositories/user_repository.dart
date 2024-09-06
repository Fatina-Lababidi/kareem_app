import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/authentication/domain/entities/login_response_entity.dart';
import 'package:careem_app_clean/features/authentication/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failures, String>> registerUser(UserEntity user);
  Future<Either<Failures, LoginResponseEntity>> loginUser(String phone, String password);
  Future<Either<Failures, String>> changePassword(
      String currentPassword, String newPassword, String confirmPassword);
}

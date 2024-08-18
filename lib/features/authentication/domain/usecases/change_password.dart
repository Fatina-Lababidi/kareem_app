
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/authentication/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase({required this.repository});

  Future<Either<Failures, String>> call(String currentPassword, String newPassword,String confirmPassword) async {
    return await repository.changePassword(currentPassword, newPassword,confirmPassword);
  }
}
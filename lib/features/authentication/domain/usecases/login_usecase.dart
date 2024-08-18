
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/authentication/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class LoginUserUseCase {
  final AuthRepository repository;

  LoginUserUseCase({required this.repository});

  Future<Either<Failures, String>> call(String phone, String password) async {
    return await repository.loginUser(phone, password);
  }
}
import 'package:careem_app_clean/core/error/failures.dart';
import 'package:careem_app_clean/features/authentication/domain/entities/user_entity.dart';
import 'package:careem_app_clean/features/authentication/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase({required this.repository});

  Future<Either<Failures, String>> call(UserEntity user) async {
    return await repository.registerUser(user);
  }
}

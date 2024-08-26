
import 'package:careem_app_clean/features/authentication/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.firstName,
    required super.lastName,
    required super.birthDate,
    required super.phone,
    required super.username,
    required super.password,
    required super.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'phone': phone,
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      firstName: user.firstName,
      lastName: user.lastName,
      birthDate: user.birthDate,
      phone: user.phone,
      username: user.username,
      password: user.password,
      confirmPassword: user.confirmPassword,
    );
  }
}

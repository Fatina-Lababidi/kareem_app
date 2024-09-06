import 'package:careem_app_clean/features/authentication/domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  LoginResponseModel({required super.token, required super.id});

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'id': id,
    };
  }

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(token: json['token'], id: json['id']);
  }
}

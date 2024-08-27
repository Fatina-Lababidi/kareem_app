import 'package:careem_app_clean/features/wallet/domain/entities/valid_code_entity.dart';

class ValidCodeModel extends ValidCodeEntity {
  ValidCodeModel(
      {required super.message, required super.status, required super.body});
  factory ValidCodeModel.fromJson(Map<String, dynamic> json) {
    return ValidCodeModel(
      message: json['message'],
      status: json['status'],
      body: (json['body'] as List<dynamic>)
          .map((item) => ValidCodeBodyModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'body': body,
    };
  }
}

class ValidCodeBodyModel extends ValidCodeBodyEntity {
  ValidCodeBodyModel(
      {required super.id, required super.code, required super.amount});

  factory ValidCodeBodyModel.fromJson(Map<String, dynamic> json) {
    return ValidCodeBodyModel(
        id: json['id'], code: json['code'], amount: json['amount']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'amount': amount,
    };
  }
}

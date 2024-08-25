import 'package:careem_app_clean/features/bicycles/data/models/bicycle_by_category_model.dart';
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_id.dart';

class BicycleByIdModel extends BicycleByIdEntity {
  BicycleByIdModel({
    required super.message,
    required super.status,
    required super.body,
  });

  factory BicycleByIdModel.formJson(Map<String, dynamic> json) {
    return BicycleByIdModel(
      message: json['message'],
      status: json['status'],
      body: BicycleModel.fromJson(json['body']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'status': status, 'body': body};
  }
}
//! we have to make sure from the body
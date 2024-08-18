import 'package:careem_app_clean/features/bicycles/domain/entities/categories_entity.dart';

class CategoriesModel extends CategoriesEntity {
  CategoriesModel({
    required super.message,
    required super.status,
    required super.body,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'body': body,
    };
  }

  factory CategoriesModel.fromEntity(CategoriesEntity categories) {
    return CategoriesModel(
        message: categories.message,
        status: categories.status,
        body: List<String>.from(categories.body));
  }
}

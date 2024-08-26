import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_ctegory_entity.dart';

class BicycleByCategoryModel extends BicycleByCtegoryEntity {
  BicycleByCategoryModel({
    required super.message,
    required super.status,
    required List<BicycleModel> super.body,
  });

  factory BicycleByCategoryModel.fromJson(Map<String, dynamic> json) {
    return BicycleByCategoryModel(
      message: json['message'],
      status: json['status'],
      body: (json['body'] as List<dynamic>)
          .map((item) => BicycleModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'body': body.map((item) => item).toList(),
    };
  }
}

class BicycleModel extends BicyclesEntity {
  BicycleModel({
    required super.id,
    required ModelPrice super.modelPrice,
    required super.size,
    required super.photoPath,
    required super.type,
    required super.note,
    required super.maintenance,
  });

  factory BicycleModel.fromJson(Map<String, dynamic> json) {
    return BicycleModel(
      id: json['id'],
      modelPrice: ModelPrice.fromJson(json['model_price']),
      size: json['size'],
      photoPath: json['photoPath'],
      type: json['type'],
      note: json['note'],
      maintenance: json['maintenance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model_price': modelPrice,
      'size': size,
      'photoPath': photoPath,
      'type': type,
      'note': note,
      'maintenance': maintenance,
    };
  }
}

class ModelPrice extends ModelPriceEntity {
  ModelPrice({
    required super.id,
    required super.price,
    required super.model,
  });

  factory ModelPrice.fromJson(Map<String, dynamic> json) {
    return ModelPrice(
      id: json['id'],
      price: json['price'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'model': model,
    };
  }
}

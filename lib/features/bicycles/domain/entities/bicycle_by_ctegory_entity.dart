// ignore_for_file: public_member_api_docs, sort_constructors_first
class ModelPriceEntity {
  final int id;
  final double price;
  final String model;
  ModelPriceEntity({
    required this.id,
    required this.price,
    required this.model,
  });
}

class BicyclesEntity {
  final int id;
  final ModelPriceEntity modelPrice;
  final int size;
  final String photoPath;
  final String type;
  final String note;
  final List<dynamic> maintenance;
  BicyclesEntity({
    required this.id,
    required this.modelPrice,
    required this.size,
    required this.photoPath,
    required this.type,
    required this.note,
    required this.maintenance,
  });
}

class BicycleByCtegoryEntity {
  final String message;
  final String status;
  final List<BicyclesEntity> body;
  BicycleByCtegoryEntity({
    required this.message,
    required this.status,
    required this.body,
  });
}

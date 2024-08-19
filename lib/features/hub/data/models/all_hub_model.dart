import 'package:careem_app_clean/features/hub/domain/entities/all_hub_entity.dart';

class PlaceModel extends PlaceEntity {
  PlaceModel(
      {required super.id,
      required super.name,
      required super.latitude,
      required super.longitude,
      required super.description});

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    };
  }
}

//? hub

class AllHubModel extends AllHubEntity {
  AllHubModel({
    required super.message,
    required super.status,
    required super.body,
  });

  factory AllHubModel.formJson(Map<String, dynamic> json) {
    return AllHubModel(
        message: json['message'],
        status: json['status'],
        body: List<PlaceModel>.from(
            json['body'].map((place) => PlaceModel.fromJson(place))));
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'body': body.map((place) => place).toList(),
    };
  }
}

import 'package:careem_app_clean/features/bicycles/data/models/bicycle_by_category_model.dart';
import 'package:careem_app_clean/features/favourite/domain/entities/add_fav_response_entity.dart';

class ClientModel extends ClientEntity {
  ClientModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.phoneNumber,
      required super.username,
      required super.birthDate});

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      username: json['username'],
      birthDate: json['birthDate'],
    );
  }
}

//bicycle we made it before

class BicycleWithNullPhotoModel extends BicyclesWithNullPhotoEntity {
  BicycleWithNullPhotoModel({
    required int id,
    required ModelPrice modelPrice,
    required int size,
    required String? photoPath,
    required String type,
    required String note,
    required List<dynamic> maintenance,
  }) : super(
          id: id,
          modelPrice: modelPrice,
          size: size,
          photoPath: photoPath,
          type: type,
          note: note,
          maintenance: maintenance,
        );

  factory BicycleWithNullPhotoModel.fromJson(Map<String, dynamic> json) {
    return BicycleWithNullPhotoModel(
      id: json['id'],
      modelPrice: ModelPrice.fromJson(json['model_price']),
      size: json['size'],
      photoPath: json['photoPath']as String?,
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



class AddFavBodyResponseModel extends AddFavResponseEntity {
  AddFavBodyResponseModel({
    required super.id,
    required super.bicycle,
    required super.client,
  });

  factory AddFavBodyResponseModel.fromJson(Map<String, dynamic> json) {
    return AddFavBodyResponseModel(
      id: json['id'],
      bicycle: BicycleWithNullPhotoModel.fromJson(json['bicycle']),
      client: ClientModel.fromJson(json['client']),
    );
  }
}

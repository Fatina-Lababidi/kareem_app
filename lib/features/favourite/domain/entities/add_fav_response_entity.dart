// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_ctegory_entity.dart';

class ClientEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String username;
  final String birthDate;
  ClientEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.username,
    required this.birthDate,
  });
}

// we have the bicycle entity

class BicyclesWithNullPhotoEntity {
  final int id;
  final ModelPriceEntity modelPrice;
  final int size;
  final String? photoPath;
  final String type;
  final String note;
  final List<dynamic> maintenance;
  BicyclesWithNullPhotoEntity({
    required this.id,
    required this.modelPrice,
    required this.size,
    required this.photoPath,
    required this.type,
    required this.note,
    required this.maintenance,
  });
}

class AddFavResponseEntity {
  final int id;
  final BicyclesWithNullPhotoEntity bicycle;
  final ClientEntity client;
  AddFavResponseEntity({
    required this.id,
    required this.bicycle,
    required this.client,
  });
}


// delete success response data :
// {
//   "message": "Delete favourite successfully",
//   "status": "OK",
//   "localDateTime": "2024-09-04T08:12:51.3169779"
// }
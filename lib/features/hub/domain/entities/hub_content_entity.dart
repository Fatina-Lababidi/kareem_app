// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_ctegory_entity.dart';

// modelPriceEntity we made it before in the bicycle
class BicycleListInHubEntity {
  final int id;
  final String type;
  final int size;
  final String note;
  final List<dynamic> maintenance;
  final List<dynamic> extension;
  final String photoPath;
  final ModelPriceEntity modelPrice;
  // final bool? hasOffer;
  // final int? discountPrice;
  BicycleListInHubEntity({
    required this.id,
    required this.type,
    required this.size,
    required this.note,
    required this.maintenance,
    required this.extension,
    required this.photoPath,
    required this.modelPrice,
  });
}

class BodyHubContentEntity {
  final int id;
  final int hubId;
  final List<BicycleListInHubEntity> bicycleList;
  final String note;
  BodyHubContentEntity({
    required this.id,
    required this.hubId,
    required this.bicycleList,
    required this.note,
  });
}

class HubContentResponseEntity {
  final String message;
  final String status;
  final BodyHubContentEntity body;
  HubContentResponseEntity({
    required this.message,
    required this.status,
    required this.body,
  });
}

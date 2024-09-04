import 'package:careem_app_clean/features/bicycles/data/models/bicycle_by_category_model.dart';
import 'package:careem_app_clean/features/hub/domain/entities/hub_content_entity.dart';

class BicycleListInHubModel extends BicycleListInHubEntity {
  BicycleListInHubModel({
    required super.id,
    required super.type,
    required super.size,
    required super.note,
    required super.maintenance,
    required super.extension,
    required super.photoPath,
    required super.modelPrice,
  });

  factory BicycleListInHubModel.fromJson(Map<String, dynamic> json) {
    return BicycleListInHubModel(
      id: json['id'],
      type: json['type'],
      size: json['size'],
      note: json['note'],
      maintenance: json['maintenance'] ?? [],
      extension: json['extension'] ?? [],
      photoPath: json['photoPath'],
      modelPrice: ModelPrice.fromJson(json['model_price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'size': size,
      'note': note,
      'maintenance': maintenance,
      'extension': extension,
      'photoPath': photoPath,
      'modelPrice': modelPrice, //.toJson ??
    };
  }
}

// 2:

class BodyHubContentModel extends BodyHubContentEntity {
  BodyHubContentModel({
    required super.id,
    required super.hubId,
    required super.bicycleList,
    required super.note,
  });

  factory BodyHubContentModel.fromJson(Map<String, dynamic> json) {
    return BodyHubContentModel(
        id: json['id'],
        hubId: json['hubId'],
        bicycleList: List<BicycleListInHubModel>.from(json['bicycleList']
            .map((bicycleList) => BicycleListInHubModel.fromJson(bicycleList))),
        note: json['note']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hubId': hubId,
      'bicycleList': bicycleList
          .map((bicycle) => bicycleList)
          .toList(), //!! have to make sure
      'note': note,
    };
  }
}

//3:

class HubContentResponseModel extends HubContentResponseEntity {
  HubContentResponseModel({
    required super.message,
    required super.status,
    required super.body,
  });

  factory HubContentResponseModel.fromJson(Map<String, dynamic> json) {
    return HubContentResponseModel(
      message: json['message'],
      status: json['status'],
      body: BodyHubContentModel.fromJson(json['body']), // json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'body': body, //!!
    };
  }
}

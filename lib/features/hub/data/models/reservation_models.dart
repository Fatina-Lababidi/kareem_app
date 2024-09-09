import 'package:careem_app_clean/features/hub/domain/entities/reservation_entity.dart';

// request model:
class ReservationRequestModel extends ReservationRequestEntity {
  ReservationRequestModel(
      {required super.bicycleId,
      required super.fromHubId,
      required super.toHubId,
      required super.duration,
      required super.startTime,
      required super.paymentMethod});

  Map<String, dynamic> toJson() {
    return {
      "bicycleId": bicycleId,
      "fromHubId": fromHubId,
      "toHubId": toHubId,
      "duration": duration,
      "startTime": startTime.toUtc(), //"2024-09-04T04:29:15.319Z".
      "paymentMethod": paymentMethod,
    };
  }

  factory ReservationRequestModel.fromEntity(ReservationRequestEntity entity) {
    return ReservationRequestModel(
      bicycleId: entity.bicycleId,
      fromHubId: entity.fromHubId,
      toHubId: entity.toHubId,
      duration: entity.duration,
      startTime: entity.startTime,
      paymentMethod: entity.paymentMethod,
    );
  }
}

//response model:

class ReservationResponseModel extends ReservationResponseEntity {
  ReservationResponseModel(
      {required super.message, required super.status, required super.body});

  factory ReservationResponseModel.fromJson(Map<String, dynamic> json) {
    return ReservationResponseModel(
      message: json['message'],
      status: json['status'],
      body: ReservationBodyModel.fromJson(json['body']),
    );
  }
}

//sub class:

class ReservationBodyModel extends ReservationBodyEntity {
  ReservationBodyModel({
    required super.id,
    required super.client,
    required super.bicycle,
    required super.from,
    required super.to,
    required super.duration,
    required super.startTime,
    super.endTime,
    required super.reservationStatus,
    required super.price,
  });

  factory ReservationBodyModel.fromJson(Map<String, dynamic> json) {
    return ReservationBodyModel(
      id: json['id'],
      client: json['client'],
      bicycle: json['bicycle'],
      from: json['from'],
      to: json['to'],
      duration: json['duration'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      reservationStatus: json['reservationStatus'],
      price: json['price'],
    );
  }
}

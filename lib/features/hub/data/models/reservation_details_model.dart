import 'package:careem_app_clean/features/hub/domain/entities/reservation_details_entity.dart';

class ReservationDetailsResponseModel extends ReservationDetailsResponseEntity {
  ReservationDetailsResponseModel(
      {required super.message, required super.status, required super.body});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'body': body.map((item) => item).toList()
    };
  }

  factory ReservationDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return ReservationDetailsResponseModel(
      message: json['message'],
      status: json['status'],
      body: (json['body'] as List)
          .map((item) => ReservationDetailsBodyModel.fromJson(item))
          .toList(),
    );
  }
}

// sub class:
class ReservationDetailsBodyModel extends ReservationDetailsBodyEntity {
  ReservationDetailsBodyModel(
      {required super.id,
      required super.client,
      required super.bicycle,
      required super.from,
      required super.to,
      required super.duration,
      required super.reservationStatus,
      required super.price});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': client,
      'bicycle': bicycle,
      'from': from,
      'to': to,
      'duration': duration,
      'reservationStatus': reservationStatus,
      'price': price,
    };
  }

  factory ReservationDetailsBodyModel.fromJson(Map<String, dynamic> json) {
    return ReservationDetailsBodyModel(
      id: json['id'],
      client: json['client'],
      bicycle: json['bicycle'],
      from: json['from'],
      to: json['to'],
      duration: (json['duration'] as num).toDouble(),
      reservationStatus: json['reservationStatus'],
      price: (json['price']as num).toDouble(),
    );
  }
}

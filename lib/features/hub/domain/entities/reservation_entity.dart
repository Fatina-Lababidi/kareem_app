
//request:

class ReservationRequestEntity {
  final int bicycleId;
  final int fromHubId;
  final int toHubId;
  final int duration;
  final DateTime startTime;
  final String paymentMethod;
  ReservationRequestEntity({
    required this.bicycleId,
    required this.fromHubId,
    required this.toHubId,
    required this.duration,
    required this.startTime,
    required this.paymentMethod,
  });
}

// response:

class ReservationResponseEntity {
  final String message;
  final String status;
  // final DateTime localDateTime;
  final ReservationBodyEntity body;
  ReservationResponseEntity({
    required this.message,
    required this.status,
    required this.body,
  });
}

class ReservationBodyEntity {
  final int id;
  final String client;
  final String bicycle;
  final String from;
  final String to;
  final int duration;
  final DateTime startTime;
  final DateTime? endTime;
  final String reservationStatus;
  final double price;

  ReservationBodyEntity({
    required this.id,
    required this.client,
    required this.bicycle,
    required this.from,
    required this.to,
    required this.duration,
    required this.startTime,
    this.endTime,
    required this.reservationStatus,
    required this.price,
  });
}

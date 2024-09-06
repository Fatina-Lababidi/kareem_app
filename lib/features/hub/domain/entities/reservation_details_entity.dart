// ignore_for_file: public_member_api_docs, sort_constructors_first
//? reservation details:
// {
//   "message": "All reservations found",
//   "status": "OK",
//   "localDateTime": "2024-09-05T09:19:15.0843696",
//   "body": [
//     {
//       "id": 4,
//       "client": "sana",
//       "bicycle": "PUE229",
//       "from": "وزارة التربية",
//       "to": "جامع صلاح الدين",
//       "duration": 1,
//       "startTime": "2024-09-04T04:29:15.319",
//       "endTime": null,
//       "reservationStatus": "PENDING",
//       "price": 900
//     }
//   ]
// }

class ReservationDetailsResponseEntity {
  final String message;
  final String status;
  final List<ReservationDetailsBodyEntity> body;
  ReservationDetailsResponseEntity({
    required this.message,
    required this.status,
    required this.body,
  });
}

class ReservationDetailsBodyEntity {
  final int id;
  final String client;
  final String bicycle;
  final String from;
  final String to;
  final num duration;
  final String reservationStatus;
  final num price;
  ReservationDetailsBodyEntity({
    required this.id,
    required this.client,
    required this.bicycle,
    required this.from,
    required this.to,
    required this.duration,
    required this.reservationStatus,
    required this.price,
  });
}

part of 'reservation_bloc.dart';

@immutable
sealed class ReservationEvent {}

class MakeReservation extends ReservationEvent {
  final ReservationRequestEntity requestEntity;
  MakeReservation({
    required this.requestEntity,
  });
}

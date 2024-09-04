part of 'reservation_bloc.dart';

@immutable
sealed class ReservationState {}

final class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationFailure extends ReservationState {
  final String message;
  ReservationFailure({
    required this.message,
  });
}

class ReservationSuccess extends ReservationState {
  final ReservationResponseEntity reservationResponseEntity;
  ReservationSuccess({
    required this.reservationResponseEntity,
  });
}

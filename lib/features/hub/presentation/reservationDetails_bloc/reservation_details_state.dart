// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reservation_details_bloc.dart';

@immutable
sealed class ReservationDetailsState {}

final class ReservationDetailsInitial extends ReservationDetailsState {}

class ReservationDetailsLoading extends ReservationDetailsState {}

class ReservationDetailsSuccess extends ReservationDetailsState {
  final ReservationDetailsResponseEntity reservationDetailsResponseEntity;
  ReservationDetailsSuccess({
    required this.reservationDetailsResponseEntity,
  });
}

class ReservationDetailsFailure extends ReservationDetailsState {
  final String message;
  ReservationDetailsFailure({
    required this.message,
  });
}

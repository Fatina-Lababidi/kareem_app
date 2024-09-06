// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reservation_details_bloc.dart';

@immutable
sealed class ReservationDetailsEvent {}

class GetReservationDetails extends ReservationDetailsEvent {
  final int clientId;
  GetReservationDetails({
    required this.clientId,
  });
}

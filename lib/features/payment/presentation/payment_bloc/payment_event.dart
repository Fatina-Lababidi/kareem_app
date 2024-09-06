// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_bloc.dart';

@immutable
sealed class PaymentEvent {}

class PayForYourReservation extends PaymentEvent {
  final PaymentRequestEntity paymentRequestEntity;
  PayForYourReservation({
    required this.paymentRequestEntity,
  });
}

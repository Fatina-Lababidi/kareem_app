// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_bloc.dart';

@immutable
sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String message;
  PaymentSuccess({
    required this.message,
  });
}

class PaymentFailure extends PaymentState {
  final String message;
  PaymentFailure({
    required this.message,
  });
}

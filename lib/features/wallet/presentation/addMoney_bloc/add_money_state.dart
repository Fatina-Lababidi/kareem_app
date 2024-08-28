// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_money_bloc.dart';

@immutable
sealed class AddMoneyState {}

final class AddMoneyInitial extends AddMoneyState {}

class AddMoneyLoading extends AddMoneyState {}

class AddMoneyFailure extends AddMoneyState {
  final String message;
  AddMoneyFailure({
    required this.message,
  });
}

class AddMoneySuccess extends AddMoneyState {
  final String message;
  AddMoneySuccess({
    required this.message,
  });
}

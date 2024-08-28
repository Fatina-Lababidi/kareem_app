// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_money_bloc.dart';

@immutable
sealed class AddMoneyEvent {}

class AddMoney extends AddMoneyEvent {
  final String code;
  AddMoney({
    required this.code,
  });
}

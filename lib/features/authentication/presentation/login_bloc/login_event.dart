// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginUserEvent extends LoginEvent {
  final String phone;
  final String password;
  LoginUserEvent({
    required this.phone,
    required this.password,
  });
}

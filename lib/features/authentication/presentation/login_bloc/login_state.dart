part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  LoginSuccess({
    required this.token,
  });
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure({required this.message});
}


class LoginOffline extends LoginState{}
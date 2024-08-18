part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final String message;
  ChangePasswordSuccess({
    required this.message,
  });
}


class ChangePasswordFailure extends ChangePasswordState {
  final String message;

  ChangePasswordFailure({required this.message});
}

class ChangePasswordOffline extends ChangePasswordState{}
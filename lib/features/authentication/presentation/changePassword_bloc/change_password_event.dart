// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordEvent {}

class ChangeUserPasswordEvent extends ChangePasswordEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  ChangeUserPasswordEvent({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

}

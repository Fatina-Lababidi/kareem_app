// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class SignUp extends RegisterEvent {
 final RegisterModel user;
  SignUp({
    required this.user,
  });
}

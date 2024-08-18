// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_bloc_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String token;
  RegisterSuccess({
    required this.token,
  });
}

class RegisterFailure extends RegisterState {
  final String message;

  RegisterFailure({required this.message});
}


class RegisterOffline extends RegisterState{}
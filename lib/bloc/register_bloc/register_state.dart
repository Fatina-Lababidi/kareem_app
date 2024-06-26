// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

class RegisterSuccess extends RegisterState {
  // final String message;
  // RegisterSuccess({
  //   required this.message,
  // });
}

class RegisterFailed extends RegisterState {
  final String message;
  RegisterFailed({
    required this.message,
  });
}

class RegisterLoading extends RegisterState {}

class OfflineRegister extends RegisterState {
  final String message;
  OfflineRegister({
    required this.message,
  });
}

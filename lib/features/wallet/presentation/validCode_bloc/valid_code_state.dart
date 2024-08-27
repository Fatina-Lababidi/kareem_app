// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'valid_code_bloc.dart';

@immutable
sealed class ValidCodeState {}

final class ValidCodeInitial extends ValidCodeState {}

class ValidCodeFailure extends ValidCodeState {
  final String message;
  ValidCodeFailure({
    required this.message,
  });
}

class ValidCodeLoading extends ValidCodeState {}

class ValidCodeSuccess extends ValidCodeState {
  final ValidCodeEntity validCodeEntity;
  ValidCodeSuccess({
    required this.validCodeEntity,
  });
}

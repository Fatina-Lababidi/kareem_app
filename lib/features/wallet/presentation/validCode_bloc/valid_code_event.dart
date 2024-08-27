part of 'valid_code_bloc.dart';

@immutable
sealed class ValidCodeEvent {}

class GetValidCode extends ValidCodeEvent{}
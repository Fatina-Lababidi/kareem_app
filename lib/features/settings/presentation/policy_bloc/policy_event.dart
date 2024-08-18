part of 'policy_bloc.dart';

@immutable
sealed class PolicyEvent {}

class GetPolicy extends PolicyEvent{}
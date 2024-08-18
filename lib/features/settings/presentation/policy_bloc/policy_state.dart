// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'policy_bloc.dart';

@immutable
sealed class PolicyState {}

final class PolicyInitial extends PolicyState {}

class PolicyLoding extends PolicyState {}

class PolicyOffline extends PolicyState {}

class PolicyFailure extends PolicyState {
  final String message;
  PolicyFailure({
    required this.message,
  });
}

class PolicySuccess extends PolicyState {
  final PolicyEntity policy;
  PolicySuccess({
    required this.policy,
  });
}

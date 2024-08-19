part of 'all_hub_bloc.dart';

@immutable
sealed class AllHubState {}

final class AllHubInitial extends AllHubState {}

class AllHubLoding extends AllHubState {}

class AllHubFailure extends AllHubState {
  final String message;
  AllHubFailure({
    required this.message,
  });
}

class AllHubSuccess extends AllHubState {
  final AllHubEntity allHubEntity;
  AllHubSuccess({
    required this.allHubEntity,
  });
}

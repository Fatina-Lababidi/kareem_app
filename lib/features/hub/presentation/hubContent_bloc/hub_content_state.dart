part of 'hub_content_bloc.dart';

@immutable
sealed class HubContentState {}

final class HubContentInitial extends HubContentState {}

class HubContentLoding extends HubContentState {}

class HubContentFailure extends HubContentState {
  final String message;
  HubContentFailure({
    required this.message,
  });
}

class HubContentSuccess extends HubContentState {
  final HubContentResponseEntity hubContentResponseEntity;
  HubContentSuccess({
    required this.hubContentResponseEntity,
  });
}

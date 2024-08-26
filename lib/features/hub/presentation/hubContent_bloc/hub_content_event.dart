part of 'hub_content_bloc.dart';

@immutable
sealed class HubContentEvent {}

class GetHubContent extends HubContentEvent {}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'fav_by_client_id_bloc.dart';

@immutable
sealed class FavByClientIdState {}

final class FavByClientIdInitial extends FavByClientIdState {}

class FavByClientIdLoading extends FavByClientIdState {}

class FavByClientIdSuccess extends FavByClientIdState {
  final List<AddFavResponseEntity> addFavResponseEntity;
  FavByClientIdSuccess({
    required this.addFavResponseEntity,
  });
}

class FavByClientIdFailure extends FavByClientIdState {
  final String message;
  FavByClientIdFailure({
    required this.message,
  });
}

part of 'delete_favourite_bloc.dart';

@immutable
sealed class DeleteFavouriteState {}

final class DeleteFavouriteInitial extends DeleteFavouriteState {}

class DeleteFavouriteLoading extends DeleteFavouriteState {}

class DeleteFavouriteFailure extends DeleteFavouriteState {
  final String message;
  DeleteFavouriteFailure({
    required this.message,
  });
}

class DeleteFavouriteSuccess extends DeleteFavouriteState {
  final String message;
  DeleteFavouriteSuccess({
    required this.message,
  });
}

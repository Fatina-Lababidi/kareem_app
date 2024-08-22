part of 'add_favourite_bloc.dart';

@immutable
sealed class AddFavouriteState {}

final class AddFavouriteInitial extends AddFavouriteState {}

class AddFavouriteLoding extends AddFavouriteState {}

class AddFavouriteFailure extends AddFavouriteState {
  final String message;
  AddFavouriteFailure({
    required this.message,
  });
}

class AddFavouriteSuccess extends AddFavouriteState {
  final AddFavResponseEntity fav;
  AddFavouriteSuccess({
    required this.fav,
  });
}

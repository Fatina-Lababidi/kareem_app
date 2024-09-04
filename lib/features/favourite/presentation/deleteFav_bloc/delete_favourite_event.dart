// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'delete_favourite_bloc.dart';

@immutable
sealed class DeleteFavouriteEvent {}

class DeleteFavouriteBike extends DeleteFavouriteEvent {
  final int favId;
  DeleteFavouriteBike({
    required this.favId,
  });
}

part of 'fav_by_client_id_bloc.dart';

@immutable
sealed class FavByClientIdEvent {}

class GetFavByClientid extends FavByClientIdEvent{}
part of 'bicycle_by_id_bloc.dart';

@immutable
sealed class BicycleByIdEvent {}

class GetBicycleById extends BicycleByIdEvent{}
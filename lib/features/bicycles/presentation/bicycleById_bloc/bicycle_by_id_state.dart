part of 'bicycle_by_id_bloc.dart';

@immutable
sealed class BicycleByIdState {}

final class BicycleByIdInitial extends BicycleByIdState {}

class BicycleByIdLoding extends BicycleByIdState {}

class BicycleByIdFailure extends BicycleByIdState {
  final String message;
  BicycleByIdFailure({
    required this.message,
  });
}

class BicycleByIdSuccess extends BicycleByIdState {
  final BicycleByIdEntity bicycleByIdEntity;
  BicycleByIdSuccess({
    required this.bicycleByIdEntity,
  });
}

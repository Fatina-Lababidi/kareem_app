part of 'bicycle_by_category_bloc.dart';

@immutable
sealed class BicycleByCategoryState {}

final class BicycleByCategoryInitial extends BicycleByCategoryState {}

class BicycleByCategoryLoding extends BicycleByCategoryState {}

class BicycleByCategoryFailure extends BicycleByCategoryState {
  final String message;
  BicycleByCategoryFailure({
    required this.message,
  });
}

class BicycleByCategorySuccess extends BicycleByCategoryState {
  final BicycleByCtegoryEntity bicycleByCtegoryEntity;
  BicycleByCategorySuccess({
    required this.bicycleByCtegoryEntity,
  });
}

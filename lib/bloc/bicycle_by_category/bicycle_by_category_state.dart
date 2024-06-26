// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bicycle_by_category_bloc.dart';

@immutable
sealed class BicycleByCategoryState {}

final class BicycleByCategoryInitial extends BicycleByCategoryState {}

class BicycleSuccess extends BicycleByCategoryState {
  final BicycleResponseModel bicycleResponse;
  BicycleSuccess({
    required this.bicycleResponse,
  });
}

class BicycleFailed extends BicycleByCategoryState {
  final String message;
  BicycleFailed({
    required this.message,
  });
}

class BicycleLoading extends BicycleByCategoryState {}

class BicycleOffline extends BicycleByCategoryState {
  final String message;
  BicycleOffline({
    required this.message,
  });
}

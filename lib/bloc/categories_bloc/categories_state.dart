// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

class CategoriesSuccess extends CategoriesState {
  final CategoriesResponseModel categoriesResponseModel;
  CategoriesSuccess({
    required this.categoriesResponseModel,
  });
}

class CategoriesFailed extends CategoriesState {
  final String message;
  CategoriesFailed({
    required this.message,
  });
}

class CategoriesLoading extends CategoriesState {}

class CategoriesOffline extends CategoriesState {
  final String message;
  CategoriesOffline({
    required this.message,
  });
}

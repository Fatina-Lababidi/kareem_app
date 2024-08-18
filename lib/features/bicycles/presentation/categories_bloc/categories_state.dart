// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

class CategoriesLoding extends CategoriesState {}

// class CategoriesOffline extends CategoriesState {
//   final String message;
//   CategoriesOffline({
//     required this.message,
//   });
// }

class CategoriesFailure extends CategoriesState {
  final String message;
  CategoriesFailure({
    required this.message,
  });
}

class CategoriesSuccess extends CategoriesState {
  final CategoriesEntity categories;
  CategoriesSuccess({
    required this.categories,
  });
}

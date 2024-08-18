part of 'categories_bloc.dart';

@immutable
sealed class CategoriesEvent {}


class GetCategories extends CategoriesEvent{}
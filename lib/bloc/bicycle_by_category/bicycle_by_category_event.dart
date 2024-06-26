// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'bicycle_by_category_bloc.dart';

@immutable
sealed class BicycleByCategoryEvent {}

class FetchBicycles extends BicycleByCategoryEvent {
  final double latitude;
  final double longitude;
  final String category;
  FetchBicycles({
    required this.latitude,
    required this.longitude,
    required this.category,
  });
}

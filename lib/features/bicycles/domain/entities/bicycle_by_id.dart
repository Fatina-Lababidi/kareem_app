import 'package:careem_app_clean/features/bicycles/domain/entities/bicycle_by_ctegory_entity.dart';

class BicycleByIdEntity {
  final String message;
  final String status;
  final BicyclesEntity body;
  BicycleByIdEntity({
    required this.message,
    required this.status,
    required this.body,
  });
}

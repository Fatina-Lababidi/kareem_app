// ignore_for_file: public_member_api_docs, sort_constructors_first
class ValidCodeEntity {
  final String message;
  final String status;
  final List<ValidCodeBodyEntity> body;
  ValidCodeEntity({
    required this.message,
    required this.status,
    required this.body,
  });
}

class ValidCodeBodyEntity {
  final int id;
  final String code;
  final num amount;
  ValidCodeBodyEntity({
    required this.id,
    required this.code,
    required this.amount,
  });
}

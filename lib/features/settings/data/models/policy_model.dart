import 'package:careem_app_clean/features/settings/domain/entities/policy_entity.dart';

class PolicyModel extends PolicyEntity {
  PolicyModel({
    required super.id,
    required super.title,
    required super.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory PolicyModel.fromEntity(PolicyEntity policy) {
    return PolicyModel(
      id: policy.id,
      title: policy.title,
      description: policy.description,
    );
  }
}

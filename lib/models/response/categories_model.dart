// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CategoriesResponseModel {
  final String message;
  final String status;
  final List<String> body;
  CategoriesResponseModel({
    required this.message,
    required this.status,
    required this.body,
  });

  CategoriesResponseModel copyWith({
    String? message,
    String? status,
    List<String>? body,
  }) {
    return CategoriesResponseModel(
      message: message ?? this.message,
      status: status ?? this.status,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'body': body,
    };
  }

  factory CategoriesResponseModel.fromMap(Map<String, dynamic> map) {
    return CategoriesResponseModel(
        message: map['message'] as String,
        status: map['status'] as String,
        body: List<String>.from(
          (map['body'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory CategoriesResponseModel.fromJson(String source) =>
      CategoriesResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CategoriesResponseModel(message: $message, status: $status, body: $body)';

  @override
  bool operator ==(covariant CategoriesResponseModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.status == status &&
        listEquals(other.body, body);
  }

  @override
  int get hashCode => message.hashCode ^ status.hashCode ^ body.hashCode;
}

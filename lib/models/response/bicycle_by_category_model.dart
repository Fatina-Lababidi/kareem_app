// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class PriceModel {
  final int id;
  final double price;
  final String model;
  PriceModel({
    required this.id,
    required this.price,
    required this.model,
  });

  PriceModel copyWith({
    int? id,
    double? price,
    String? model,
  }) {
    return PriceModel(
      id: id ?? this.id,
      price: price ?? this.price,
      model: model ?? this.model,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'price': price,
      'model': model,
    };
  }

  factory PriceModel.fromMap(Map<String, dynamic> map) {
    return PriceModel(
      id: map['id'] as int,
      price: map['price'] as double,
      model: map['model'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceModel.fromJson(String source) =>
      PriceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PriceModel(id: $id, price: $price, model: $model)';

  @override
  bool operator ==(covariant PriceModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.price == price && other.model == model;
  }

  @override
  int get hashCode => id.hashCode ^ price.hashCode ^ model.hashCode;
}

//body:
class Bicycle {
  final int id;
  final PriceModel modelPrice;
  final int size;
  final String type;
  final String note;
  final List<dynamic> maintenance;
  Bicycle({
    required this.id,
    required this.modelPrice,
    required this.size,
    required this.type,
    required this.note,
    required this.maintenance,
  });

  Bicycle copyWith({
    int? id,
    PriceModel? modelPrice,
    int? size,
    String? type,
    String? note,
    List<dynamic>? maintenance,
  }) {
    return Bicycle(
      id: id ?? this.id,
      modelPrice: modelPrice ?? this.modelPrice,
      size: size ?? this.size,
      type: type ?? this.type,
      note: note ?? this.note,
      maintenance: maintenance ?? this.maintenance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'modelPrice': modelPrice.toMap(),
      'size': size,
      'type': type,
      'note': note,
      'maintenance': maintenance,
    };
  }

  factory Bicycle.fromMap(Map<String, dynamic> map) {
    return Bicycle(
        id: map['id'] as int,
        modelPrice:
            PriceModel.fromMap(map['modelPrice'] as Map<String, dynamic>),
        size: map['size'] as int,
        type: map['type'] as String,
        note: map['note'] as String,
        maintenance: List<dynamic>.from(
          (map['maintenance'] as List<dynamic>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory Bicycle.fromJson(String source) =>
      Bicycle.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Bicycle(id: $id, modelPrice: $modelPrice, size: $size, type: $type, note: $note, maintenance: $maintenance)';
  }

  @override
  bool operator ==(covariant Bicycle other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.modelPrice == modelPrice &&
        other.size == size &&
        other.type == type &&
        other.note == note &&
        listEquals(other.maintenance, maintenance);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        modelPrice.hashCode ^
        size.hashCode ^
        type.hashCode ^
        note.hashCode ^
        maintenance.hashCode;
  }
}

// response:
class BicycleResponseModel {
  final String message;
  final String status;
  final List<Bicycle> body;
  BicycleResponseModel({
    required this.message,
    required this.status,
    required this.body,
  });

  BicycleResponseModel copyWith({
    String? message,
    String? status,
    List<Bicycle>? body,
  }) {
    return BicycleResponseModel(
      message: message ?? this.message,
      status: status ?? this.status,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'status': status,
      'body': body.map((x) => x.toMap()).toList(),
    };
  }

  factory BicycleResponseModel.fromMap(Map<String, dynamic> map) {
    return BicycleResponseModel(
      message: map['message'] as String,
      status: map['status'] as String,
      body: List<Bicycle>.from((map['body'] as List<int>).map<Bicycle>((x) => Bicycle.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory BicycleResponseModel.fromJson(String source) => BicycleResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BicycleResponseModel(message: $message, status: $status, body: $body)';

  @override
  bool operator ==(covariant BicycleResponseModel other) {
    if (identical(this, other)) return true;

    return
      other.message == message &&
      other.status == status &&
      listEquals(other.body, body);
  }

  @override
  int get hashCode => message.hashCode ^ status.hashCode ^ body.hashCode;
}

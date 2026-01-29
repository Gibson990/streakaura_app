import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'tag_model.g.dart';

@HiveType(typeId: 2)
class Tag extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int colorValue; // Store color as int

  @HiveField(3)
  DateTime createdAt;

  Tag({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.createdAt,
  });

  Color get color => Color(colorValue);

  Tag copyWith({
    String? id,
    String? name,
    int? colorValue,
    DateTime? createdAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}


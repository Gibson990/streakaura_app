import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 3)
class Project extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String emoji;

  @HiveField(3)
  int colorValue; // Store color as int

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  bool isArchived;

  @HiveField(6)
  bool isArea; // True if this is an Area, false if Project

  @HiveField(7)
  String? areaId; // If this is a project, link to area

  Project({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorValue,
    required this.createdAt,
    this.isArchived = false,
    this.isArea = false,
    this.areaId,
  });

  Color get color => Color(colorValue);

  Project copyWith({
    String? id,
    String? name,
    String? emoji,
    int? colorValue,
    DateTime? createdAt,
    bool? isArchived,
    bool? isArea,
    String? areaId,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      isArchived: isArchived ?? this.isArchived,
      isArea: isArea ?? this.isArea,
      areaId: areaId ?? this.areaId,
    );
  }
}


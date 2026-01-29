import 'package:hive/hive.dart';

part 'subtask_model.g.dart';

@HiveType(typeId: 1)
class Subtask extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  DateTime createdAt;

  Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
  });
}


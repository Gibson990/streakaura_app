import 'package:hive/hive.dart';

import '../models/habit_model.dart';

class HabitRepository {
  final Box<Habit> _localBox;
  final dynamic firestore; // Use dynamic to avoid import error
  final String? userId;

  HabitRepository(this._localBox, {this.firestore, this.userId});

  Stream<List<Habit>> watchHabits() {
    return _localBox.watch().map((_) => _localBox.values.toList());
  }

  List<Habit> getAllHabits() {
    return _localBox.values.toList();
  }

  List<Habit> getHabitsByProject(String projectId) {
    return _localBox.values
        .where((h) => h.projectId == projectId && !h.isArchived)
        .toList();
  }

  List<Habit> getHabitsByTag(String tagId) {
    return _localBox.values
        .where((h) => h.tags.contains(tagId) && !h.isArchived)
        .toList();
  }

  List<Habit> getHabitsByDueDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return _localBox.values
        .where((h) {
          if (h.dueDate == null || h.isArchived) return false;
          final habitDateOnly = DateTime(
            h.dueDate!.year,
            h.dueDate!.month,
            h.dueDate!.day,
          );
          return habitDateOnly.isAtSameMomentAs(dateOnly);
        })
        .toList();
  }

  List<Habit> getHabitsByPriority(int priority) {
    return _localBox.values
        .where((h) => h.priority == priority && !h.isArchived)
        .toList();
  }

  List<Habit> searchHabits(String query) {
    final lowerQuery = query.toLowerCase();
    return _localBox.values
        .where((h) {
          if (h.isArchived) return false;
          return h.name.toLowerCase().contains(lowerQuery) ||
              (h.description?.toLowerCase().contains(lowerQuery) ?? false);
        })
        .toList();
  }

  List<Habit> getArchivedHabits() {
    return _localBox.values.where((h) => h.isArchived).toList();
  }

  Future<void> addHabit(Habit habit) async {
    await _localBox.put(habit.id, habit);
    
    // Cloud sync skipped as Firebase is not initialized
    // if (firestore != null && userId != null) { ... }
  }

  Future<void> updateHabit(Habit habit) async {
    await habit.save();
    
    // Cloud sync skipped as Firebase is not initialized
    // if (firestore != null && userId != null) { ... }
  }

  Future<void> deleteHabit(String id) async {
    await _localBox.delete(id);
    
    // Cloud sync skipped as Firebase is not initialized
    // if (firestore != null && userId != null) { ... }
  }

  Future<void> archiveHabit(String id) async {
    final habit = _localBox.get(id);
    if (habit != null) {
      habit.isArchived = true;
      habit.completedAt = DateTime.now();
      await habit.save();
    }
  }

  Future<void> unarchiveHabit(String id) async {
    final habit = _localBox.get(id);
    if (habit != null) {
      habit.isArchived = false;
      habit.completedAt = null;
      await habit.save();
    }
  }

  Future<void> syncFromCloud() async {
    // Cloud sync skipped as Firebase is not initialized
    return;
  }
}

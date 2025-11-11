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

  Future<void> syncFromCloud() async {
    // Cloud sync skipped as Firebase is not initialized
    return;
  }
}

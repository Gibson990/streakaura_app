import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/habit_model.dart';
import '../data/repositories/habit_repository.dart';
import '../core/constants/app_constants.dart';
import '../services/sound_service.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// 1. Repository Provider
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final localBox = Hive.box<Habit>(AppConstants.habitsBox);

  final firestore = ref.watch(firestoreProvider);
  final userId = ref.watch(authStateProvider).value;

  return HabitRepository(localBox, firestore: firestore, userId: userId);
});

// 2. Auth State Provider
final authStateProvider = StreamProvider<String?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return auth.authStateChanges().map((user) => user?.uid);
});

// 3. Habits Stream Provider
final habitsStreamProvider = StreamProvider<List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.watchHabits();
});

// 4. Habits List Provider (Using the stream to get the list)
final habitsListProvider = Provider<List<Habit>>((ref) {
  return ref.watch(habitsStreamProvider).value ?? [];
});

// 5. Habit Service Provider (For business logic)
final habitServiceProvider = Provider((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return HabitService(repository);
});

class HabitService {
  final HabitRepository _repository;

  HabitService(this._repository);

  Future<void> addHabit(Habit habit) async {
    await _repository.addHabit(habit);
  }

  Future<void> toggleCheckIn(Habit habit) async {
    final today = DateTime.now();

    final isCheckedIn = habit.checkIns.any(
      (d) =>
          d.year == today.year && d.month == today.month && d.day == today.day,
    );

    if (isCheckedIn) {
      // Remove today's check-in
      habit.checkIns.removeWhere(
        (d) =>
            d.year == today.year &&
            d.month == today.month &&
            d.day == today.day,
      );
    } else {
      // Add today's check-in
      habit.checkIns.add(today);
      // Play sound
      await _playCheckInSound();
    }

    // Recalculate streaks
    final oldStreak = habit.currentStreak;
    habit.calculateCurrentStreak();

    await _repository.updateHabit(habit);

    // Check for streak milestones
    if (!isCheckedIn && habit.currentStreak > oldStreak) {
      await _checkStreakMilestone(habit);
    }
  }

  Future<void> _playCheckInSound() async {
    await SoundService.playCheckInSound();
  }

  Future<void> _checkStreakMilestone(Habit habit) async {
    if (habit.currentStreak == 7 ||
        habit.currentStreak == 30 ||
        habit.currentStreak == 100) {
      await SoundService.playStreakMilestoneSound();
    }
  }

  Future<void> deleteHabit(String id) async {
    await _repository.deleteHabit(id);
  }

  // Other habit-related business logic can go here
}

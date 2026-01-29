import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/habit_model.dart';
import '../data/repositories/habit_repository.dart';
import '../core/constants/app_constants.dart';
import '../services/sound_service.dart';

// 1. Repository Provider
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final localBox = Hive.box<Habit>(AppConstants.habitsBox);
  // Mocking a logged-out state since Firebase is not initialized
  final firestore = null;
  final userId = null;
  
  return HabitRepository(localBox, firestore: firestore, userId: userId);
});

// 2. Auth State Provider (Mocked since Firebase is not initialized)
final authStateProvider = StreamProvider<String?>((ref) {
  // Mocking a logged-out state for now
  return Stream.value(null); 
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
    
    final isCheckedIn = habit.checkIns.any((d) => 
      d.year == today.year && d.month == today.month && d.day == today.day
    );

    if (isCheckedIn) {
      // Remove today's check-in
      habit.checkIns.removeWhere((d) => 
        d.year == today.year && d.month == today.month && d.day == today.day
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
    if (habit.currentStreak == 7 || habit.currentStreak == 30 || habit.currentStreak == 100) {
      await SoundService.playStreakMilestoneSound();
    }
  }

  Future<void> deleteHabit(String id) async {
    await _repository.deleteHabit(id);
  }

  Future<void> archiveHabit(String id) async {
    await _repository.archiveHabit(id);
  }

  Future<void> unarchiveHabit(String id) async {
    await _repository.unarchiveHabit(id);
  }
  
  // Other habit-related business logic can go here
}

// Filtered Providers
final todayHabitsProvider = Provider<List<Habit>>((ref) {
  final allHabits = ref.watch(habitsListProvider);
  final today = DateTime.now();
  final todayMidnight = DateTime(today.year, today.month, today.day);
  
  return allHabits.where((habit) {
    if (habit.isArchived) return false;
    // Show habits due today or overdue
    if (habit.dueDate != null) {
      final dueDateMidnight = DateTime(
        habit.dueDate!.year,
        habit.dueDate!.month,
        habit.dueDate!.day,
      );
      return dueDateMidnight.isBefore(todayMidnight) || 
             dueDateMidnight.isAtSameMomentAs(todayMidnight);
    }
    // Show daily habits that haven't been checked in today
    if (habit.isDaily) {
      final hasCheckedInToday = habit.checkIns.any((d) {
        final checkInMidnight = DateTime(d.year, d.month, d.day);
        return checkInMidnight.isAtSameMomentAs(todayMidnight);
      });
      return !hasCheckedInToday;
    }
    return false;
  }).toList();
});

final upcomingHabitsProvider = Provider<List<Habit>>((ref) {
  final allHabits = ref.watch(habitsListProvider);
  final today = DateTime.now();
  final todayMidnight = DateTime(today.year, today.month, today.day);
  
  return allHabits.where((habit) {
    if (habit.isArchived || habit.dueDate == null) return false;
    final dueDateMidnight = DateTime(
      habit.dueDate!.year,
      habit.dueDate!.month,
      habit.dueDate!.day,
    );
    return dueDateMidnight.isAfter(todayMidnight);
  }).toList()
    ..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
});

final habitsByProjectProvider = Provider.family<List<Habit>, String>((ref, projectId) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabitsByProject(projectId);
});

final habitsByTagProvider = Provider.family<List<Habit>, String>((ref, tagId) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getHabitsByTag(tagId);
});

final archivedHabitsProvider = Provider<List<Habit>>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return repository.getArchivedHabits();
});

final searchHabitsProvider = Provider.family<List<Habit>, String>((ref, query) {
  if (query.isEmpty) return [];
  final repository = ref.watch(habitRepositoryProvider);
  return repository.searchHabits(query);
});

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streakaura_app/core/constants/app_constants.dart';
import 'package:streakaura_app/data/models/habit_model.dart';
import 'package:streakaura_app/data/repositories/habit_repository.dart';
import 'package:streakaura_app/providers/habit_provider.dart';

void main() {
  late HabitRepository repository;

  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());
    await Hive.openBox<Habit>(AppConstants.habitsBox);
  });

  setUp(() {
    final box = Hive.box<Habit>(AppConstants.habitsBox);
    box.clear();
    repository = HabitRepository(box);
  });

  tearDown(() {
    final box = Hive.box<Habit>(AppConstants.habitsBox);
    box.clear();
  });

  group('HabitService', () {
    test('adds habit successfully', () async {
      final service = HabitService(repository);
      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        emoji: '📚',
        createdAt: DateTime.now(),
        checkIns: [],
        isDaily: true,
        weeklyGoal: 7,
        currentStreak: 0,
      );

      await service.addHabit(habit);

      final allHabits = repository.getAllHabits();
      expect(allHabits.length, 1);
      expect(allHabits.first.id, 'test-1');
      expect(allHabits.first.name, 'Test Habit');
    });

    test('toggles check-in correctly', () async {
      final service = HabitService(repository);
      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        emoji: '📚',
        createdAt: DateTime.now(),
        checkIns: [],
        isDaily: true,
        weeklyGoal: 7,
        currentStreak: 0,
      );

      await service.addHabit(habit);

      // First check-in
      await service.toggleCheckIn(habit);
      expect(habit.checkIns.length, 1);

      // Uncheck
      await service.toggleCheckIn(habit);
      expect(habit.checkIns.length, 0);
    });

    test('deletes habit successfully', () async {
      final service = HabitService(repository);
      final habit = Habit(
        id: 'test-1',
        name: 'Test Habit',
        emoji: '📚',
        createdAt: DateTime.now(),
        checkIns: [],
        isDaily: true,
        weeklyGoal: 7,
        currentStreak: 0,
      );

      await service.addHabit(habit);
      expect(repository.getAllHabits().length, 1);

      await service.deleteHabit('test-1');
      expect(repository.getAllHabits().length, 0);
    });
  });
}


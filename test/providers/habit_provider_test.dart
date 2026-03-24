import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:streakaura_app/core/constants/app_constants.dart';
import 'package:streakaura_app/data/models/habit_model.dart';
import 'package:streakaura_app/data/repositories/habit_repository.dart';
import 'package:streakaura_app/providers/habit_provider.dart';
import 'package:streakaura_app/services/sound_service.dart';

void main() {
  late HabitRepository repository;
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('streakaura_hive_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }
    await Hive.openBox<Habit>(AppConstants.habitsBox);
    SoundService.configure(enabled: false);
  });

  setUp(() async {
    final box = Hive.box<Habit>(AppConstants.habitsBox);
    await box.clear();
    repository = HabitRepository(box);
  });

  tearDown(() async {
    final box = Hive.box<Habit>(AppConstants.habitsBox);
    await box.clear();
  });

  tearDownAll(() async {
    await Hive.box<Habit>(AppConstants.habitsBox).close();
    await Hive.deleteBoxFromDisk(AppConstants.habitsBox);
    await tempDir.delete(recursive: true);
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

      final box = Hive.box<Habit>(AppConstants.habitsBox);
      expect(box.length, 1);
      final stored = box.get('test-1');
      expect(stored, isNotNull);
      expect(stored!.name, 'Test Habit');
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
      final box = Hive.box<Habit>(AppConstants.habitsBox);
      final storedHabit = box.get('test-1')!;

      // First check-in
      await service.toggleCheckIn(storedHabit);
      expect(storedHabit.checkIns.length, 1);

      // Uncheck
      await service.toggleCheckIn(storedHabit);
      expect(storedHabit.checkIns.length, 0);
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
      final box = Hive.box<Habit>(AppConstants.habitsBox);
      expect(box.length, 1);

      await service.deleteHabit('test-1');
      expect(box.length, 0);
    });
  });
}

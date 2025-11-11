import 'package:flutter_test/flutter_test.dart';
import 'package:streakaura_app/data/models/habit_model.dart';
import 'package:streakaura_app/services/gamification_service.dart';

void main() {
  group('GamificationService', () {
    test('returns empty list for habit with no check-ins', () {
      final habit = Habit(
        id: '1',
        name: 'Test',
        emoji: '📚',
        createdAt: DateTime.now(),
        checkIns: [],
        isDaily: true,
        weeklyGoal: 7,
        currentStreak: 0,
      );

      final badges = GamificationService.getUnlockedBadges(habit);
      expect(badges, isEmpty);
    });

    test('unlocks first check badge', () {
      final habit = Habit(
        id: '1',
        name: 'Test',
        emoji: '📚',
        createdAt: DateTime.now(),
        checkIns: [DateTime.now()],
        isDaily: true,
        weeklyGoal: 7,
        currentStreak: 1,
      );
      habit.calculateCurrentStreak();

      final badges = GamificationService.getUnlockedBadges(habit);
      expect(badges.length, greaterThan(0));
      expect(badges.any((b) => b.id == 'first_check'), true);
    });

    test('unlocks week warrior badge at 7 days', () {
      final habit = Habit(
        id: '1',
        name: 'Test',
        emoji: '📚',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        checkIns: List.generate(7, (i) => DateTime.now().subtract(Duration(days: 6 - i))),
        isDaily: true,
        weeklyGoal: 7,
        currentStreak: 7,
      );
      habit.calculateCurrentStreak();

      final badges = GamificationService.getUnlockedBadges(habit);
      expect(badges.any((b) => b.id == 'week_warrior'), true);
    });

    test('unlocks multi-tasker badge for 5+ habits', () {
      final habits = List.generate(5, (i) => Habit(
        id: '$i',
        name: 'Habit $i',
        emoji: '📚',
        createdAt: DateTime.now(),
        checkIns: [],
        isDaily: true,
        weeklyGoal: 7,
        currentStreak: 0,
      ));

      final badges = GamificationService.getUnlockedBadgesOverall(habits, 50);
      expect(badges.any((b) => b.id == 'multi_tasker'), true);
    });

    test('unlocks radiant aura badge at 90+ score', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Test',
          emoji: '📚',
          createdAt: DateTime.now(),
          checkIns: [DateTime.now()],
          isDaily: true,
          weeklyGoal: 7,
          currentStreak: 1,
        ),
      ];

      final badges = GamificationService.getUnlockedBadgesOverall(habits, 95);
      expect(badges.any((b) => b.id == 'aura_radiant'), true);
    });
  });
}


import 'package:flutter_test/flutter_test.dart';
import 'package:streakaura_app/data/models/habit_model.dart';
import 'package:streakaura_app/services/aura_score_service.dart';

void main() {
  group('AuraScoreService', () {
    test('calculates score for empty habits list', () {
      final score = AuraScoreService.calculateAuraScore([]);
      expect(score, 0);
    });

    test('calculates score for single habit with check-ins', () {
      final habit = Habit(
        id: '1',
        name: 'Test Habit',
        emoji: '📚',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        checkIns: [
          DateTime.now().subtract(const Duration(days: 1)),
          DateTime.now(),
        ],
        isDaily: true,
        weeklyGoal: 7,
        currentStreak: 2,
      );
      habit.calculateCurrentStreak();

      final score = AuraScoreService.calculateAuraScore([habit]);
      expect(score, greaterThan(0));
      expect(score, lessThanOrEqualTo(100));
    });

    test('calculates higher score for multiple completed habits', () {
      final habits = [
        Habit(
          id: '1',
          name: 'Habit 1',
          emoji: '📚',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          checkIns: [DateTime.now()],
          isDaily: true,
          weeklyGoal: 7,
          currentStreak: 1,
        ),
        Habit(
          id: '2',
          name: 'Habit 2',
          emoji: '🏃',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          checkIns: [DateTime.now()],
          isDaily: true,
          weeklyGoal: 7,
          currentStreak: 1,
        ),
        Habit(
          id: '3',
          name: 'Habit 3',
          emoji: '🧘',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          checkIns: [DateTime.now()],
          isDaily: true,
          weeklyGoal: 7,
          currentStreak: 1,
        ),
      ];

      for (var habit in habits) {
        habit.calculateCurrentStreak();
      }

      final score = AuraScoreService.calculateAuraScore(habits);
      expect(score, greaterThan(30)); // Should be higher with multiple habits
      expect(score, lessThanOrEqualTo(100));
    });

    test('returns appropriate aura label', () {
      expect(AuraScoreService.getAuraLabel(95), 'Radiant 🌟');
      expect(AuraScoreService.getAuraLabel(80), 'Glowing ✨');
      expect(AuraScoreService.getAuraLabel(65), 'Shining 💫');
      expect(AuraScoreService.getAuraLabel(50), 'Bright 💡');
      expect(AuraScoreService.getAuraLabel(35), 'Flickering 🕯️');
      expect(AuraScoreService.getAuraLabel(20), 'Dim 🌑');
    });
  });
}


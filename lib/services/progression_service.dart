import '../data/models/habit_model.dart';

/// Lightweight XP/level progression service for gamified UI.
class ProgressionService {
  static const int xpPerCheckIn = 10;
  static const int xpPerLevel = 100;

  static int calculateXp(List<Habit> habits) {
    return habits.fold<int>(
      0,
      (total, habit) => total + (habit.checkIns.length * xpPerCheckIn),
    );
  }

  static int levelForXp(int xp) {
    return (xp ~/ xpPerLevel) + 1;
  }

  static int xpIntoLevel(int xp) {
    return xp % xpPerLevel;
  }

  static int xpToNextLevel(int xp) {
    return xpPerLevel - xpIntoLevel(xp);
  }

  static double levelProgress(int xp) {
    return xpIntoLevel(xp) / xpPerLevel;
  }
}

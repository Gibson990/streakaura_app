import '../data/models/habit_model.dart';

/// Badge/Achievement system
class Badge {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final int requiredValue;

  Badge({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.requiredValue,
  });
}

class GamificationService {
  static final List<Badge> allBadges = [
    Badge(
      id: 'first_check',
      name: 'First Glow',
      emoji: '✨',
      description: 'Complete your first check-in',
      requiredValue: 1,
    ),
    Badge(
      id: 'week_warrior',
      name: 'Week Warrior',
      emoji: '🔥',
      description: '7-day streak',
      requiredValue: 7,
    ),
    Badge(
      id: 'month_master',
      name: 'Month Master',
      emoji: '🌟',
      description: '30-day streak',
      requiredValue: 30,
    ),
    Badge(
      id: 'century_club',
      name: 'Century Club',
      emoji: '💎',
      description: '100-day streak',
      requiredValue: 100,
    ),
    Badge(
      id: 'multi_tasker',
      name: 'Multi-Tasker',
      emoji: '🎯',
      description: '5 active habits',
      requiredValue: 5,
    ),
    Badge(
      id: 'aura_radiant',
      name: 'Radiant Aura',
      emoji: '⚡',
      description: 'Reach 90+ Aura Score',
      requiredValue: 90,
    ),
  ];

  /// Get badge requirement/rules text
  static String getBadgeRequirement(String badgeId) {
    switch (badgeId) {
      case 'first_check':
        return 'Complete your first check-in on any habit';
      case 'week_warrior':
        return 'Maintain a 7-day streak on any habit';
      case 'month_master':
        return 'Maintain a 30-day streak on any habit';
      case 'century_club':
        return 'Maintain a 100-day streak on any habit';
      case 'multi_tasker':
        return 'Have 5 or more active habits';
      case 'aura_radiant':
        return 'Reach an Aura Score of 90 or higher';
      default:
        return 'Unknown requirement';
    }
  }

  /// Get unlocked badges for a habit
  static List<Badge> getUnlockedBadges(Habit habit) {
    return allBadges.where((badge) {
      switch (badge.id) {
        case 'first_check':
          return habit.checkIns.isNotEmpty;
        case 'week_warrior':
          return habit.currentStreak >= 7;
        case 'month_master':
          return habit.currentStreak >= 30;
        case 'century_club':
          return habit.currentStreak >= 100;
        default:
          return false;
      }
    }).toList();
  }

  /// Get unlocked badges for overall progress
  static List<Badge> getUnlockedBadgesOverall(
    List<Habit> habits,
    int auraScore,
  ) {
    return allBadges.where((badge) {
      switch (badge.id) {
        case 'multi_tasker':
          return habits.length >= 5;
        case 'aura_radiant':
          return auraScore >= 90;
        default:
          return false;
      }
    }).toList();
  }

  /// Check if a new badge was just unlocked
  static Badge? checkNewBadgeUnlocked(
    Habit habit,
    List<Habit> allHabits,
    int auraScore,
  ) {
    // Check for milestone badges
    if (habit.currentStreak == 7 && habit.currentStreak > 6) {
      return allBadges.firstWhere((b) => b.id == 'week_warrior');
    }
    if (habit.currentStreak == 30 && habit.currentStreak > 29) {
      return allBadges.firstWhere((b) => b.id == 'month_master');
    }
    if (habit.currentStreak == 100 && habit.currentStreak > 99) {
      return allBadges.firstWhere((b) => b.id == 'century_club');
    }
    if (auraScore >= 90 && auraScore < 91) {
      return allBadges.firstWhere((b) => b.id == 'aura_radiant');
    }

    return null;
  }
}


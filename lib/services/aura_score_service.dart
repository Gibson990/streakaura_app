import '../data/models/habit_model.dart';

/// Calculates the Aura Score (0-100) based on habit consistency and balance
class AuraScoreService {
  /// Calculate Aura Score for all habits
  /// 
  /// Formula:
  /// - Consistency: 50% (based on current streaks vs goals)
  /// - Balance: 30% (variety of habits completed today)
  /// - Momentum: 20% (recent activity trend)
  static int calculateAuraScore(List<Habit> habits) {
    if (habits.isEmpty) return 0;

    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    
    // Calculate consistency (50 points max)
    double consistencyScore = 0;
    int activeHabits = 0;
    
    for (var habit in habits) {
      habit.calculateCurrentStreak();
      
      // Check if habit was completed today
      final completedToday = habit.checkIns.any((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day
      );
      
      if (completedToday) {
        activeHabits++;
      }
      
      // Consistency based on streak vs goal
      final target = habit.isDaily ? 7 : habit.weeklyGoal;
      final streakRatio = habit.currentStreak / target.clamp(1, 7);
      consistencyScore += (completedToday ? 1.0 : 0.5) * streakRatio.clamp(0.0, 1.0);
    }
    
    consistencyScore = (consistencyScore / habits.length.clamp(1, double.infinity)) * 50;
    
    // Calculate balance (30 points max)
    // Reward variety: completing different habits
    final balanceScore = (activeHabits / habits.length.clamp(1, double.infinity)) * 30;
    
    // Calculate momentum (20 points max)
    // Based on recent activity (last 7 days)
    double momentumScore = 0;
    final last7Days = List.generate(7, (i) => 
      todayMidnight.subtract(Duration(days: i))
    );
    
    int recentCheckIns = 0;
    for (var habit in habits) {
      for (var checkIn in habit.checkIns) {
        final checkInDay = DateTime(checkIn.year, checkIn.month, checkIn.day);
        if (last7Days.any((day) => day.isAtSameMomentAs(checkInDay))) {
          recentCheckIns++;
        }
      }
    }
    
    final expectedCheckIns = habits.length * 7; // Max possible in 7 days
    momentumScore = (recentCheckIns / expectedCheckIns.clamp(1, double.infinity)) * 20;
    
    // Total score
    final totalScore = (consistencyScore + balanceScore + momentumScore).round();
    return totalScore.clamp(0, 100);
  }
  
  /// Get Aura Score label/emoji based on score
  static String getAuraLabel(int score) {
    if (score >= 90) return 'Radiant 🌟';
    if (score >= 75) return 'Glowing ✨';
    if (score >= 60) return 'Shining 💫';
    if (score >= 45) return 'Bright 💡';
    if (score >= 30) return 'Flickering 🕯️';
    return 'Dim 🌑';
  }
}


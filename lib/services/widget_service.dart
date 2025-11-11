import 'package:home_widget/home_widget.dart';
import '../data/models/habit_model.dart';

/// Service for updating home/lock screen widgets
class WidgetService {
  static const String _widgetName = 'StreakAuraWidget';
  
  /// Update widget with current streak data
  static Future<void> updateWidget(List<Habit> habits) async {
    try {
      if (habits.isEmpty) {
        await HomeWidget.saveWidgetData<String>('streak_text', 'No habits yet');
        await HomeWidget.saveWidgetData<String>('aura_score', '0');
        await HomeWidget.updateWidget(name: _widgetName);
        return;
      }
      
      // Calculate active habits today
      int activeToday = 0;
      
      for (var habit in habits) {
        habit.calculateCurrentStreak();
        
        final today = DateTime.now();
        final isCheckedToday = habit.checkIns.any((d) =>
          d.year == today.year && d.month == today.month && d.day == today.day
        );
        
        if (isCheckedToday) {
          activeToday++;
        }
      }
      
      // Find habit with longest streak
      final longestStreakHabit = habits.reduce((a, b) =>
        a.currentStreak > b.currentStreak ? a : b
      );
      
      // Calculate time until streak ends (if not checked today)
      String countdownText = '';
      final today = DateTime.now();
      final tomorrow = DateTime(today.year, today.month, today.day + 1);
      final hoursLeft = tomorrow.difference(DateTime.now()).inHours;
      
      if (hoursLeft < 24) {
        countdownText = '${hoursLeft}h left';
      }
      
      // Update widget data
      await HomeWidget.saveWidgetData<String>(
        'streak_text',
        longestStreakHabit.currentStreak > 0
            ? '${longestStreakHabit.emoji} ${longestStreakHabit.currentStreak} days 🔥'
            : 'Start your glow! ✨',
      );
      
      await HomeWidget.saveWidgetData<String>(
        'countdown_text',
        countdownText.isNotEmpty ? 'Streak ends in $countdownText' : '',
      );
      
      await HomeWidget.saveWidgetData<String>(
        'active_today',
        '$activeToday/${habits.length}',
      );
      
      // Update widget (works for both Android and iOS)
      await HomeWidget.updateWidget(name: _widgetName);
      
      // For iOS, also update via App Group UserDefaults
      // This is handled automatically by home_widget package
    } catch (e) {
      // Widget update failed - silently continue
      // This is expected on platforms without widget support
    }
  }
}


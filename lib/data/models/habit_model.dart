import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'subtask_model.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  String emoji;
  
  @HiveField(3)
  String? description;
  
  @HiveField(4)
  DateTime createdAt;
  
  @HiveField(5)
  List<DateTime> checkIns;
  
  @HiveField(6)
  TimeOfDay? reminderTime;
  
  @HiveField(7)
  bool isDaily;
  
  @HiveField(8)
  int weeklyGoal;
  
  @HiveField(9)
  int currentStreak;
  
  @HiveField(10)
  String template;

  @HiveField(11)
  String? projectId;

  @HiveField(12)
  List<String> tags;

  @HiveField(13)
  DateTime? dueDate;

  @HiveField(14)
  int priority; // 0=none, 1=low, 2=medium, 3=high

  @HiveField(15)
  List<Subtask> subtasks;

  @HiveField(16)
  int? timeEstimateMinutes; // Store as minutes for Hive compatibility

  @HiveField(17)
  String? recurrencePattern;

  @HiveField(18)
  bool isArchived;

  @HiveField(19)
  DateTime? completedAt;
  
  Habit({
    required this.id,
    required this.name,
    required this.emoji,
    this.description,
    required this.createdAt,
    required this.checkIns,
    this.reminderTime,
    this.isDaily = true,
    this.weeklyGoal = 7,
    this.currentStreak = 0,
    this.template = 'custom',
    this.projectId,
    List<String>? tags,
    this.dueDate,
    this.priority = 0,
    List<Subtask>? subtasks,
    this.timeEstimateMinutes,
    this.recurrencePattern,
    this.isArchived = false,
    this.completedAt,
  })  : tags = tags ?? [],
        subtasks = subtasks ?? [];

  Duration? get timeEstimate => 
      timeEstimateMinutes != null 
          ? Duration(minutes: timeEstimateMinutes!) 
          : null;

  set timeEstimate(Duration? value) {
    timeEstimateMinutes = value?.inMinutes;
  }

  int get longestStreak {
    if (checkIns.isEmpty) return 0;
    
    int maxStreak = 0;
    int current = 0;
    DateTime? lastDate;
    
    // Sort and normalize dates to midnight for accurate streak calculation
    final sortedDates = checkIns.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList()..sort();
    
    for (var date in sortedDates) {
      if (lastDate == null) {
        current = 1;
      } else {
        // Check if the current date is the day after the last date
        final difference = date.difference(lastDate).inDays;
        if (difference == 1) {
          current++;
        } else if (difference > 1) {
          maxStreak = current > maxStreak ? current : maxStreak;
          current = 1;
        }
      }
      lastDate = date;
    }
    
    return current > maxStreak ? current : maxStreak;
  }

  void calculateCurrentStreak() {
    if (checkIns.isEmpty) {
      currentStreak = 0;
      return;
    }
    
    // Normalize check-in dates to midnight and get unique days
    final uniqueCheckInDays = checkIns.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList()..sort();
    
    if (uniqueCheckInDays.isEmpty) {
      currentStreak = 0;
      return;
    }
    
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    
    // Check if the last check-in was today or yesterday
    final lastCheckInDay = uniqueCheckInDays.last;
    
    if (lastCheckInDay.isBefore(todayMidnight.subtract(const Duration(days: 1)))) {
      // Last check-in was before yesterday, streak is 0
      currentStreak = 0;
      return;
    }
    
    int streak = 0;
    DateTime streakDate = todayMidnight;
    
    // If the last check-in was today, start counting from today
    if (lastCheckInDay.isAtSameMomentAs(todayMidnight)) {
      streakDate = todayMidnight;
    } else if (lastCheckInDay.isAtSameMomentAs(todayMidnight.subtract(const Duration(days: 1)))) {
      // If the last check-in was yesterday, start counting from yesterday
      streakDate = todayMidnight.subtract(const Duration(days: 1));
    } else {
      // Should not happen based on the check above, but as a fallback
      currentStreak = 0;
      return;
    }
    
    // Iterate backwards from the starting streakDate
    for (int i = uniqueCheckInDays.length - 1; i >= 0; i--) {
      final checkDay = uniqueCheckInDays[i];
      
      if (checkDay.isAtSameMomentAs(streakDate)) {
        streak++;
        streakDate = streakDate.subtract(const Duration(days: 1));
      } else if (checkDay.isBefore(streakDate)) {
        // The checkDay is before the expected streakDate, so the streak is broken
        break;
      }
      // If checkDay is after streakDate, it means we missed a day, but the initial check should handle this.
    }
    
    currentStreak = streak;
  }
}

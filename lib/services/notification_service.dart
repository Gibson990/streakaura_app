import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'sound_service.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings);
    tz.initializeTimeZones();
  }

  Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // Enhanced notification messages with emoji and better copy
    final enhancedTitle = '✨ $title';
    final enhancedBody = '$body 🔥 Keep your glow alive!';
    final androidDetails = const AndroidNotificationDetails(
      'habit_reminders',
      'Habit Reminders',
      channelDescription: 'Daily habit reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id,
      enhancedTitle,
      enhancedBody,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedule habit reminder with custom message
  Future<void> scheduleHabitReminder({
    required int id,
    required String habitName,
    required String emoji,
    required int hour,
    required int minute,
  }) async {
    final title = '✨ Time to glow!';
    final body = '$emoji $habitName - Your streak is waiting! 🔥';
    await scheduleDailyReminder(
      id: id,
      title: title,
      body: body,
      hour: hour,
      minute: minute,
    );
  }

  /// Cancel a scheduled reminder
  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id);
  }

  /// Cancel all reminders
  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
  }
}


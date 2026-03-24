import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

/// Service for playing sound effects
class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _enabled = true;

  /// Enable or disable playback and haptics. Useful for tests where platform
  /// channels aren't available.
  static void configure({required bool enabled}) {
    _enabled = enabled;
  }

  /// Play check-in success sound
  static Future<void> playCheckInSound() async {
    if (!_enabled) return;

    try {
      // Try to play custom sound, fallback to haptic
      await _player.play(AssetSource('sounds/check_in.mp3'));
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Fallback to haptic only if sound file not found
      await HapticFeedback.lightImpact();
    }
  }

  /// Play streak milestone sound
  static Future<void> playStreakMilestoneSound() async {
    if (!_enabled) return;

    try {
      await _player.play(AssetSource('sounds/milestone.mp3'));
      await HapticFeedback.mediumImpact();
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Play achievement unlock sound
  static Future<void> playAchievementSound() async {
    if (!_enabled) return;

    try {
      await _player.play(AssetSource('sounds/achievement.mp3'));
      await HapticFeedback.heavyImpact();
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }

  /// Play notification sound
  static Future<void> playNotificationSound() async {
    if (!_enabled) return;

    try {
      await _player.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      // Silent fail for notifications
    }
  }
}

import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

/// Service for playing sound effects
class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  
  /// Play check-in success sound
  static Future<void> playCheckInSound() async {
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
    try {
      await _player.play(AssetSource('sounds/milestone.mp3'));
      await HapticFeedback.mediumImpact();
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }
  
  /// Play achievement unlock sound
  static Future<void> playAchievementSound() async {
    try {
      await _player.play(AssetSource('sounds/achievement.mp3'));
      await HapticFeedback.heavyImpact();
    } catch (e) {
      await HapticFeedback.heavyImpact();
    }
  }
  
  /// Play notification sound
  static Future<void> playNotificationSound() async {
    try {
      await _player.play(AssetSource('sounds/notification.mp3'));
    } catch (e) {
      // Silent fail for notifications
    }
  }
}


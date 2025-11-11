import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/apple_payment_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import 'dart:io' show Platform;

class PremiumGate {
  static bool _cachedPremiumStatus = false;
  static bool _hasChecked = false;

  /// Check premium status (cached)
  static bool get isPremium {
    if (!_hasChecked) {
      _refresh();
    }
    return _cachedPremiumStatus;
  }

  /// Refresh premium status from payment service
  static Future<void> refresh() async {
    if (Platform.isIOS) {
      _cachedPremiumStatus = await ApplePaymentService.checkPremiumStatus();
    } else {
      // For Android/Razorpay, check local storage
      // In production, verify with backend
      final settingsBox = Hive.box(AppConstants.settingsBox);
      _cachedPremiumStatus = settingsBox.get('is_premium', defaultValue: false) as bool;
    }
    _hasChecked = true;
  }

  /// Internal refresh (synchronous, uses cache)
  static void _refresh() {
    if (Platform.isIOS) {
      // For iOS, we need async check, so default to false until checked
      _cachedPremiumStatus = false;
    } else {
      final settingsBox = Hive.box(AppConstants.settingsBox);
      _cachedPremiumStatus = settingsBox.get('is_premium', defaultValue: false) as bool;
    }
    _hasChecked = true;
  }

  /// Set premium status (for Android/Razorpay after successful payment)
  static Future<void> setPremium(bool isPremium) async {
    _cachedPremiumStatus = isPremium;
    _hasChecked = true;
    final settingsBox = Hive.box(AppConstants.settingsBox);
    await settingsBox.put('is_premium', isPremium);
  }
}

/// Provider for premium status (reactive)
final premiumStatusProvider = FutureProvider<bool>((ref) async {
  await PremiumGate.refresh();
  return PremiumGate.isPremium;
});


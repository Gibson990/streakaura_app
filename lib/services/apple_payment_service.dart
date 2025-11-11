import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'payment_service.dart';

/// Apple Pay / RevenueCat payment service
class ApplePaymentService implements PaymentService {
  static const String _monthlyPackageId = 'monthly_premium';
  static const String _annualPackageId = 'annual_premium';
  static const String _entitlementId = 'premium';

  @override
  Future<bool> purchaseMonthly() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        throw Exception('No offerings available');
      }

      Package? package;
      // Try to find monthly package
      package = offerings.current!.availablePackages.firstWhere(
        (p) => p.identifier == _monthlyPackageId,
        orElse: () => offerings.current!.availablePackages.first,
      );

      final purchaserInfo = await Purchases.purchasePackage(package);
      return purchaserInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      if (e is PlatformException && e.code == 'USER_CANCELLED') {
        return false;
      }
      rethrow;
    }
  }

  @override
  Future<bool> purchaseAnnual() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        throw Exception('No offerings available');
      }

      Package? package;
      // Try to find annual package
      package = offerings.current!.availablePackages.firstWhere(
        (p) => p.identifier == _annualPackageId,
        orElse: () => offerings.current!.availablePackages.last,
      );

      final purchaserInfo = await Purchases.purchasePackage(package);
      return purchaserInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      if (e is PlatformException && e.code == 'USER_CANCELLED') {
        return false;
      }
      rethrow;
    }
  }

  @override
  Future<bool> restorePurchases() async {
    try {
      final purchaserInfo = await Purchases.restorePurchases();
      return purchaserInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      rethrow;
    }
  }

  /// Check if user has active premium subscription
  static Future<bool> checkPremiumStatus() async {
    try {
      final purchaserInfo = await Purchases.getCustomerInfo();
      return purchaserInfo.entitlements.active.containsKey(_entitlementId);
    } catch (e) {
      return false;
    }
  }
}


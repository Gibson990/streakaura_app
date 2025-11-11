import 'dart:io' show Platform;
import 'apple_payment_service.dart';
import 'razorpay_payment_service.dart';

/// Abstract payment service interface
abstract class PaymentService {
  Future<bool> purchaseMonthly();
  Future<bool> purchaseAnnual();
  Future<bool> restorePurchases();
  
  static PaymentService get instance {
    if (Platform.isIOS) {
      return ApplePaymentService();
    } else {
      return RazorpayPaymentService();
    }
  }
}


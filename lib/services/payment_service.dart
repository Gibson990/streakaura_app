import '../utils/platform.dart';
import 'apple_payment_service.dart';
import 'razorpay_payment_service.dart';

/// Abstract payment service interface
abstract class PaymentService {
  Future<bool> purchaseMonthly();
  Future<bool> purchaseAnnual();
  Future<bool> restorePurchases();

  static bool get isSupportedPlatform => platformIsIOS || platformIsAndroid;

  static PaymentService get instance {
    if (platformIsIOS) {
      return ApplePaymentService();
    }

    if (platformIsAndroid) {
      return RazorpayPaymentService();
    }

    return const _UnsupportedPaymentService();
  }
}

class _UnsupportedPaymentService implements PaymentService {
  const _UnsupportedPaymentService();

  UnsupportedError get _error =>
      UnsupportedError('In-app purchases are not supported on this platform.');

  @override
  Future<bool> purchaseAnnual() => Future.error(_error);

  @override
  Future<bool> purchaseMonthly() => Future.error(_error);

  @override
  Future<bool> restorePurchases() => Future.error(_error);
}

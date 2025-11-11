import 'dart:async';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../config/payment_config.dart';
import '../features/pro/premium_gate.dart';
import 'payment_service.dart';

/// Razorpay UPI payment service for Android
class RazorpayPaymentService implements PaymentService {
  late Razorpay _razorpay;
  Completer<bool>? _purchaseCompleter;
  bool _isMonthly = true;

  RazorpayPaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Future<bool> purchaseMonthly() async {
    _isMonthly = true;
    return _initiatePayment(499); // ₹499 = $4.99 (approximate)
  }

  @override
  Future<bool> purchaseAnnual() async {
    _isMonthly = false;
    return _initiatePayment(3900); // ₹3900 = $39 (approximate)
  }

  @override
  Future<bool> restorePurchases() async {
    // Razorpay doesn't support restore - this would need backend verification
    // For now, return false and show message
    throw UnimplementedError(
      'Restore purchases not available. Contact support if you have an active subscription.',
    );
  }

  Future<bool> _initiatePayment(int amountInPaise) async {
    _purchaseCompleter = Completer<bool>();

    final options = {
      'key': PaymentConfig.razorpayKeyId,
      'amount': amountInPaise * 100, // Convert to paise
      'name': 'StreakAura',
      'description': _isMonthly
          ? 'Monthly Premium Subscription'
          : 'Annual Premium Subscription',
      'prefill': {
        'contact': '',
        'email': '',
      },
      'external': {
        'wallets': ['paytm', 'phonepe', 'gpay'],
      },
    };

    try {
      _razorpay.open(options);
      return await _purchaseCompleter!.future;
    } catch (e) {
      _purchaseCompleter?.completeError(e);
      return false;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // TODO: Verify payment with backend
    // For now, mark as successful and save to local storage
    await PremiumGate.setPremium(true);
    _purchaseCompleter?.complete(true);
    _purchaseCompleter = null;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _purchaseCompleter?.complete(false);
    _purchaseCompleter = null;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // User selected external wallet (Paytm, PhonePe, etc.)
    // Payment will be handled by the wallet app
  }

  void dispose() {
    _razorpay.clear();
  }
}


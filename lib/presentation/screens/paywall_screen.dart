import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'dart:io' show Platform;
import '../../core/constants/app_constants.dart';
import '../../services/payment_service.dart';
import '../../services/apple_payment_service.dart';
import '../../services/razorpay_payment_service.dart';
import '../../features/pro/premium_gate.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _selectedAnnual = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        actions: [
          TextButton(
            onPressed: _restorePurchases,
            child: const Text('Restore'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppConstants.primaryIndigo, AppConstants.lavender],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text(
                    '🌟',
                    style: TextStyle(fontSize: 64),
                  ),
                  const Gap(16),
                  Text(
                    'Unlock Your Full Glow',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(8),
                  Text(
                    'Unlimited habits, templates, widgets & more',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.87),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Gap(32),
            
            // Subscription Options
            Text(
              'Choose Your Plan',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const Gap(16),
            
            // Monthly Plan
            _SubscriptionCard(
              title: 'Monthly',
              price: '\$4.99',
              period: 'per month',
              isSelected: !_selectedAnnual,
              onTap: () => setState(() => _selectedAnnual = false),
              savings: null,
            ),
            const Gap(12),
            
            // Annual Plan
            _SubscriptionCard(
              title: 'Annual',
              price: '\$29.99',
              period: 'per year',
              isSelected: _selectedAnnual,
              onTap: () => setState(() => _selectedAnnual = true),
              savings: 'Save 50%',
            ),
            const Gap(32),
            
            // Features Comparison
            Text(
              'Premium Features',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const Gap(16),
            _FeatureItem(icon: '✨', text: 'Unlimited habits'),
            _FeatureItem(icon: '📄', text: 'PDF progress reports'),
            _FeatureItem(icon: '🎨', text: 'Glow Templates'),
            _FeatureItem(icon: '📱', text: 'Home & Lock screen widgets'),
            _FeatureItem(icon: '☁️', text: 'Cloud sync (coming soon)'),
            _FeatureItem(icon: '🎯', text: 'Advanced analytics'),
            const Gap(32),
            
            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red[300]),
                ),
              ),
            if (_errorMessage != null) const Gap(16),
            
            // Purchase Button
            FilledButton(
              onPressed: _isLoading ? null : _handlePurchase,
              style: FilledButton.styleFrom(
                backgroundColor: AppConstants.accentTeal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      Platform.isIOS
                          ? 'Subscribe with Apple Pay'
                          : 'Subscribe with UPI',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const Gap(16),
            
            // Terms & Privacy
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: Open terms URL
                  },
                  child: const Text('Terms of Service'),
                ),
                Text(
                  ' • ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Open privacy URL
                  },
                  child: const Text('Privacy Policy'),
                ),
              ],
            ),
            const Gap(8),
            Text(
              'Subscription auto-renews. Cancel anytime in App Store settings.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePurchase() async {
    // Show payment method selection dialog
    if (!mounted) return;
    
    final paymentMethod = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Choose Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.apple),
              title: const Text('Apple Pay'),
              subtitle: const Text('Pay with Apple Pay'),
              onTap: () => Navigator.of(ctx).pop('apple'),
            ),
            if (Platform.isAndroid) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: const Text('UPI'),
                subtitle: const Text('Pay with UPI'),
                onTap: () => Navigator.of(ctx).pop('upi'),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (paymentMethod == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      PaymentService paymentService;
      if (paymentMethod == 'apple' || Platform.isIOS) {
        paymentService = ApplePaymentService();
      } else {
        paymentService = RazorpayPaymentService();
      }

      final success = _selectedAnnual
          ? await paymentService.purchaseAnnual()
          : await paymentService.purchaseMonthly();

      if (success && mounted) {
        // Refresh premium status
        PremiumGate.refresh();
        
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Welcome to Premium! ✨'),
            backgroundColor: AppConstants.accentTeal,
          ),
        );
      } else if (mounted) {
        setState(() {
          _errorMessage = 'Purchase cancelled or failed. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final paymentService = PaymentService.instance;
      final restored = await paymentService.restorePurchases();

      if (restored && mounted) {
        PremiumGate.refresh();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Purchases restored! ✨'),
            backgroundColor: AppConstants.accentTeal,
          ),
        );
      } else if (mounted) {
        setState(() {
          _errorMessage = 'No purchases found to restore.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error restoring: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _SubscriptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final bool isSelected;
  final VoidCallback onTap;
  final String? savings;

  const _SubscriptionCard({
    required this.title,
    required this.price,
    required this.period,
    required this.isSelected,
    required this.onTap,
    this.savings,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.accentTeal.withOpacity(0.2)
              : Theme.of(context).colorScheme.surface,
          border: Border.all(
            color: isSelected
                ? AppConstants.accentTeal
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppConstants.accentTeal
                      : Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
                color: isSelected ? AppConstants.accentTeal : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      if (savings != null) ...[
                        const Gap(8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppConstants.accentTeal,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            savings!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Gap(4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 28,
                            ),
                      ),
                      const Gap(4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          period,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String icon;
  final String text;

  const _FeatureItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const Gap(12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: AppConstants.accentTeal,
            size: 20,
          ),
        ],
      ),
    );
  }
}

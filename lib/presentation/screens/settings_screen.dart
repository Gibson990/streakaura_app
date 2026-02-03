import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../core/constants/app_constants.dart';
import '../../features/pro/premium_gate.dart';
import '../../services/pdf_service.dart';
import '../../services/gamification_service.dart' as gamification;
import '../../services/aura_score_service.dart';
import '../../data/models/habit_model.dart';
import '../../providers/habit_provider.dart';
import 'templates_screen.dart';
import 'paywall_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsListProvider);
    final isPremium = PremiumGate.isPremium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Premium Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isPremium ? Icons.star : Icons.star_border,
                        color: isPremium
                            ? AppConstants.accentTeal
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPremium ? 'Premium Active' : 'Free Plan',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            Text(
                              isPremium
                                  ? 'Unlimited habits & features'
                                  : '${habits.length}/${AppConstants.freeHabitLimit} habits',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!isPremium) ...[
                    const Gap(16),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PaywallScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.upgrade),
                      label: const Text('Upgrade to Premium'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppConstants.accentTeal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Gap(32),
          // Templates Section
          Text(
            'Templates',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const Gap(16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.auto_awesome),
              title: const Text('Glow Templates'),
              subtitle: const Text('Pre-made habit packs to get started'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TemplatesScreen()),
                );
              },
            ),
          ),
          const Gap(32),
          // Badges Section
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const Gap(16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text('View Badges'),
              subtitle: Text(
                '${gamification.GamificationService.getUnlockedBadgesOverall(habits, AuraScoreService.calculateAuraScore(habits)).length}/${gamification.GamificationService.allBadges.length} unlocked',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showBadgesDialog(context, habits);
              },
            ),
          ),
          const Gap(24),
          // Export Section
          Text(
            'Export & Backup',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const Gap(12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export Habit Report'),
              subtitle: Text(
                isPremium
                    ? 'Generate PDF report of your progress'
                    : 'Premium feature - Upgrade to export',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: isPremium
                  ? () async {
                      if (!context.mounted) return;
                      final navigatorContext = context;
                      try {
                        final pdfBytes = await PdfService.generateHabitReport(
                          habits: habits,
                        );
                        await PdfService.sharePdf(
                          navigatorContext,
                          pdfBytes,
                          'StreakAura_Report.pdf',
                        );
                        if (navigatorContext.mounted) {
                          ScaffoldMessenger.of(navigatorContext).showSnackBar(
                            const SnackBar(
                              content: Text('Report exported successfully!'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (navigatorContext.mounted) {
                          ScaffoldMessenger.of(navigatorContext).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                            ),
                          );
                        }
                      }
                    }
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Upgrade to Premium to export reports'),
                        ),
                      );
                    },
            ),
          ),
          const Gap(32),
          // About Section
          Text(
            'About',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const Gap(16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
            ),
          ),
          const Gap(8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Made with ❤️'),
              subtitle: Text(AppConstants.tagline),
            ),
          ),
          const Gap(48),
        ],
      ),
    );
  }

  void _showBadgesDialog(BuildContext context, List<Habit> habits) {
    final auraScore = AuraScoreService.calculateAuraScore(habits);
    final unlockedBadges = <gamification.Badge>[];
    
    // Collect all unlocked badges
    for (var habit in habits) {
      unlockedBadges.addAll(gamification.GamificationService.getUnlockedBadges(habit));
    }
    unlockedBadges.addAll(
      gamification.GamificationService.getUnlockedBadgesOverall(habits, auraScore),
    );
    
    // Remove duplicates
    final uniqueBadges = unlockedBadges.toSet().toList();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Your Badges'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: gamification.GamificationService.allBadges.length,
            itemBuilder: (context, index) {
              final badge = gamification.GamificationService.allBadges[index];
              final isUnlocked = uniqueBadges.any((b) => b.id == badge.id);
              
              return ExpansionTile(
                leading: Text(
                  badge.emoji,
                  style: TextStyle(
                    fontSize: 32,
                    color: isUnlocked
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                title: Text(
                  badge.name,
                  style: TextStyle(
                    color: isUnlocked
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  badge.description,
                  style: TextStyle(
                    color: isUnlocked
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withOpacity(0.6),
                  ),
                ),
                trailing: isUnlocked
                    ? const Icon(Icons.check_circle, color: AppConstants.accentTeal)
                    : Icon(
                        Icons.lock,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'How to unlock: ${gamification.GamificationService.getBadgeRequirement(badge.id)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

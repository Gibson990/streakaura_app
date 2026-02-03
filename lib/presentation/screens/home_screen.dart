import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/habit_provider.dart';
import '../../features/habits/presentation/widgets/habit_list_item.dart';
import '../../services/aura_score_service.dart';
import '../../services/gamification_service.dart';
import '../../services/widget_service.dart';
import '../../services/sound_service.dart';
import '../../services/progression_service.dart';
import '../../presentation/widgets/aura_score_ring.dart';
import '../../presentation/widgets/badge_dialog.dart';
import '../../presentation/widgets/streak_milestone_dialog.dart';
import 'add_edit_habit_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsListProvider);
    final habitService = ref.read(habitServiceProvider);
    final auraScore = AuraScoreService.calculateAuraScore(habits);
    final xp = ProgressionService.calculateXp(habits);
    final level = ProgressionService.levelForXp(xp);
    final levelProgress = ProgressionService.levelProgress(xp);
    final xpToNext = ProgressionService.xpToNextLevel(xp);
    final today = DateTime.now();
    final completedToday = habits.where((habit) {
      return habit.checkIns.any((d) =>
          d.year == today.year && d.month == today.month && d.day == today.day);
    }).length;
    final dailyGoal = habits.isEmpty ? 1 : habits.length;
    final dailyProgress = completedToday / dailyGoal;
    
    // Update widget when habits change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetService.updateWidget(habits);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: habits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AuraScoreRing(score: 0, size: 150),
                  const SizedBox(height: 24),
                  Text(
                    'No habits yet. Tap + to add one!',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.tagline,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                // Aura Score Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        AuraScoreRing(score: auraScore, size: 180),
                        const SizedBox(height: 16),
                        Text(
                          'Your Daily Glow',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.flash_on),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Glow Level $level',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium,
                                          ),
                                          Text(
                                            '$xp XP • $xpToNext XP to next level',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: levelProgress,
                                    minHeight: 8,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      'Daily Quest',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '$completedToday/$dailyGoal completed',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: dailyProgress,
                                    minHeight: 8,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Habits List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final habit = habits[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: HabitListItem(
                            habit: habit,
                            onToggle: () async {
                              final oldStreak = habit.currentStreak;
                              await habitService.toggleCheckIn(habit);
                              await SoundService.playCheckInSound();
                              
                              // Check for streak milestone (7, 30, 100 days)
                              final isMilestone = (habit.currentStreak == 7 && oldStreak < 7) ||
                                  (habit.currentStreak == 30 && oldStreak < 30) ||
                                  (habit.currentStreak == 100 && oldStreak < 100);
                              
                              if (isMilestone && context.mounted) {
                                await SoundService.playStreakMilestoneSound();
                                await showDialog(
                                  context: context,
                                  builder: (_) => StreakMilestoneDialog(
                                    streak: habit.currentStreak,
                                    habitName: habit.name,
                                    emoji: habit.emoji,
                                  ),
                                );
                              }
                              
                              // Check for badge unlock
                              final allHabits = ref.read(habitsListProvider);
                              final newAuraScore = AuraScoreService.calculateAuraScore(allHabits);
                              final newBadge = GamificationService.checkNewBadgeUnlocked(
                                habit,
                                allHabits,
                                newAuraScore,
                              );
                              
                              if (newBadge != null && context.mounted) {
                                // Play achievement sound
                                await SoundService.playAchievementSound();
                                await showDialog(
                                  context: context,
                                  builder: (_) => BadgeDialog(badge: newBadge),
                                );
                              }
                            },
                          ),
                        );
                      },
                      childCount: habits.length,
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEditHabitScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

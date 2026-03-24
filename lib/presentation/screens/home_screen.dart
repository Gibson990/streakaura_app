import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/habit_model.dart';
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
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final completedToday = habits.where((habit) {
      return habit.checkIns.any(
        (d) =>
            d.year == today.year &&
            d.month == today.month &&
            d.day == today.day,
      );
    }).length;
    final dailyGoal = habits.isEmpty ? 1 : habits.length;
    final dailyProgress = completedToday / dailyGoal;
    final reminderGapHabits = habits
        .where((habit) => habit.reminderTime == null)
        .toList();
    final reminderHighlight = reminderGapHabits.isNotEmpty
        ? reminderGapHabits.first
        : null;
    final streakRecoveryInsight = _findStreakRecoveryInsight(
      habits,
      todayMidnight,
    );

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
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
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
                                            .withValues(alpha: 0.12),
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
                                            style: Theme.of(
                                              context,
                                            ).textTheme.displayMedium,
                                          ),
                                          Text(
                                            '$xp XP • $xpToNext XP to next level',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
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
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      'Daily Quest',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '$completedToday/$dailyGoal completed',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: dailyProgress,
                                    minHeight: 8,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceVariant,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                if (reminderHighlight != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: _ReminderSafetyCard(
                        habit: reminderHighlight,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddEditHabitScreen(habit: reminderHighlight),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                if (streakRecoveryInsight != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: _StreakRecoveryPanel(
                        insight: streakRecoveryInsight,
                        onRescue: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddEditHabitScreen(
                                habit: streakRecoveryInsight.habit,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                // Habits List
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
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
                            final isMilestone =
                                (habit.currentStreak == 7 && oldStreak < 7) ||
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
                            final newAuraScore =
                                AuraScoreService.calculateAuraScore(allHabits);
                            final newBadge =
                                GamificationService.checkNewBadgeUnlocked(
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
                    }, childCount: habits.length),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const AddEditHabitScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

_StreakRecoveryInsight? _findStreakRecoveryInsight(
  List<Habit> habits,
  DateTime todayMidnight,
) {
  _StreakRecoveryInsight? best;

  for (final habit in habits) {
    if (habit.checkIns.isEmpty) continue;

    final uniqueDays =
        habit.checkIns
            .map((d) => DateTime(d.year, d.month, d.day))
            .toSet()
            .toList()
          ..sort();

    final lastCheckIn = uniqueDays.last;
    final daysSince = todayMidnight.difference(lastCheckIn).inDays;

    if (daysSince < 1 || daysSince > 5) {
      continue;
    }

    final priorStreak = _recentStreakLength(uniqueDays);
    if (priorStreak < 3) {
      continue;
    }

    final insight = _StreakRecoveryInsight(
      habit: habit,
      daysMissed: daysSince,
      priorStreakLength: priorStreak,
    );

    if (best == null) {
      best = insight;
      continue;
    }

    final bestScore = best!.score;
    final candidateScore = insight.score;
    if (candidateScore > bestScore ||
        (candidateScore == bestScore &&
            insight.daysMissed < best!.daysMissed)) {
      best = insight;
    }
  }

  return best;
}

int _recentStreakLength(List<DateTime> sortedDays) {
  if (sortedDays.isEmpty) return 0;

  int streak = 1;
  for (int i = sortedDays.length - 1; i > 0; i--) {
    final current = sortedDays[i];
    final previous = sortedDays[i - 1];
    if (current.difference(previous).inDays == 1) {
      streak++;
    } else {
      break;
    }
  }
  return streak;
}

class _ReminderSafetyCard extends StatelessWidget {
  const _ReminderSafetyCard({required this.habit, required this.onTap});

  final Habit habit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              AppConstants.accentTeal.withValues(alpha: 0.2),
              AppConstants.primaryIndigo.withValues(alpha: 0.18),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.32)),
          boxShadow: [
            BoxShadow(
              color: AppConstants.accentTeal.withValues(alpha: 0.22),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
              ),
              child: Text(habit.emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keep ${habit.name} glowing',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Set a gentle reminder so ${habit.emoji} never fades into the background.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.82),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: const Icon(Icons.alarm_rounded),
                    label: const Text('Add reminder'),
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

class _StreakRecoveryPanel extends StatelessWidget {
  const _StreakRecoveryPanel({required this.insight, required this.onRescue});

  final _StreakRecoveryInsight insight;
  final VoidCallback onRescue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final daysMissed = insight.daysMissed;
    final missDescription = daysMissed == 1
        ? 'Missed yesterday'
        : 'Missed ${daysMissed} days';

    final encouragement = daysMissed <= 2
        ? 'Glow rescue window still open — one tap brings it back!'
        : 'Let’s restart the glow and rebuild that momentum.';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryIndigo.withValues(alpha: 0.18),
            Colors.black.withValues(alpha: 0.35),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.22),
                ),
                child: const Icon(
                  Icons.auto_awesome_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  '${insight.habit.emoji} ${insight.habit.name} streak dimmed',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Chip(
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                label: Text(
                  missDescription,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Chip(
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                label: Text(
                  '${insight.priorStreakLength} day glow run',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            encouragement,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: onRescue,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Plan a comeback'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  scaffoldMessenger
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          'You got this! Try stacking ${insight.habit.emoji} after another habit to stay consistent.',
                        ),
                        duration: const Duration(seconds: 4),
                      ),
                    );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text('Need a pep talk'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StreakRecoveryInsight {
  const _StreakRecoveryInsight({
    required this.habit,
    required this.daysMissed,
    required this.priorStreakLength,
  });

  final Habit habit;
  final int daysMissed;
  final int priorStreakLength;

  int get score => (priorStreakLength * 100) - (daysMissed * 5);
}

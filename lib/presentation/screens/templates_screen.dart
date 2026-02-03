import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/habit_model.dart';
import '../../providers/habit_provider.dart';
import '../../features/pro/premium_gate.dart';
import 'paywall_screen.dart';

class HabitTemplate {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final List<HabitTemplateItem> habits;
  final Color color;

  HabitTemplate({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.habits,
    required this.color,
  });
}

class HabitTemplateItem {
  final String name;
  final String emoji;
  final bool isDaily;
  final int weeklyGoal;

  HabitTemplateItem({
    required this.name,
    required this.emoji,
    this.isDaily = true,
    this.weeklyGoal = 7,
  });
}

class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  static final List<HabitTemplate> templates = [
    HabitTemplate(
      id: 'study_sprint',
      name: 'Study Sprint',
      emoji: '📚',
      description: 'Perfect for exam prep and learning',
      color: AppConstants.primaryIndigo,
      habits: [
        HabitTemplateItem(name: 'Study 2 hours', emoji: '📖', isDaily: true),
        HabitTemplateItem(name: 'Review notes', emoji: '📝', isDaily: true),
        HabitTemplateItem(name: 'Practice problems', emoji: '✏️', isDaily: true),
      ],
    ),
    HabitTemplate(
      id: 'parent_power',
      name: 'Parent Power',
      emoji: '👨‍👩‍👧‍👦',
      description: 'Morning routines and family time',
      color: AppConstants.lavender,
      habits: [
        HabitTemplateItem(name: 'Pack lunch', emoji: '🥪', isDaily: true),
        HabitTemplateItem(name: 'Wake kids on time', emoji: '⏰', isDaily: true),
        HabitTemplateItem(name: 'Family dinner', emoji: '🍽️', isDaily: true),
      ],
    ),
    HabitTemplate(
      id: 'creator_flow',
      name: 'Creator Flow',
      emoji: '🎨',
      description: 'Build your creative practice',
      color: AppConstants.accentTeal,
      habits: [
        HabitTemplateItem(name: 'Edit 1 hour', emoji: '🎥', isDaily: true),
        HabitTemplateItem(name: 'Post content', emoji: '📱', weeklyGoal: 3, isDaily: false),
        HabitTemplateItem(name: 'Engage with audience', emoji: '💬', isDaily: true),
      ],
    ),
    HabitTemplate(
      id: 'deep_work',
      name: 'Deep Work',
      emoji: '🧠',
      description: 'Focused productivity blocks',
      color: AppConstants.primaryIndigo,
      habits: [
        HabitTemplateItem(name: 'Deep work 2 hours', emoji: '🎯', isDaily: true),
        HabitTemplateItem(name: 'No distractions', emoji: '🔇', isDaily: true),
      ],
    ),
    HabitTemplate(
      id: 'wellness_glow',
      name: 'Wellness Glow',
      emoji: '🧘',
      description: 'Mindfulness and movement',
      color: AppConstants.lavender,
      habits: [
        HabitTemplateItem(name: 'Walk 30 mins', emoji: '🚶‍♀️', isDaily: true),
        HabitTemplateItem(name: 'Meditate 10 mins', emoji: '🧘‍♀️', isDaily: true),
        HabitTemplateItem(name: 'Drink water', emoji: '💧', isDaily: true),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.read(habitsListProvider);
    final isPremium = PremiumGate.isPremium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Glow Templates'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Choose a template to get started',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const Gap(8),
          Text(
            'Pre-made habit packs for different lifestyles',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(24),
          ...templates.map((template) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                child: InkWell(
                  onTap: () => _applyTemplate(context, ref, template, habits, isPremium),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: template.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                template.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            const Gap(16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    template.name,
                                    style: Theme.of(context).textTheme.displayMedium,
                                  ),
                                  const Gap(4),
                                  Text(
                                    template.description,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: template.habits.map((habit) {
                            return Chip(
                              label: Text('${habit.emoji} ${habit.name}'),
                              backgroundColor: template.color.withOpacity(0.1),
                              side: BorderSide(
                                color: template.color.withOpacity(0.3),
                              ),
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                            );
                          }).toList(),
                        ),
                        const Gap(12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${template.habits.length} habits',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const Gap(8),
                            Icon(
                              Icons.arrow_forward,
                              color: template.color,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _applyTemplate(
    BuildContext context,
    WidgetRef ref,
    HabitTemplate template,
    List<Habit> existingHabits,
    bool isPremium,
  ) async {
    final habitService = ref.read(habitServiceProvider);
    // Check premium limit
    final totalAfter = existingHabits.length + template.habits.length;
    if (!isPremium && totalAfter > AppConstants.freeHabitLimit) {
      if (context.mounted) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Premium required'),
            content: Text(
              'This template adds ${template.habits.length} habits. '
              'Free plan allows ${AppConstants.freeHabitLimit} total. '
              'Upgrade to Premium for unlimited habits.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PaywallScreen(),
                    ),
                  );
                },
                child: const Text('Upgrade'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Add all habits from template
    for (var item in template.habits) {
      final habit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString() + item.name,
        name: item.name,
        emoji: item.emoji,
        createdAt: DateTime.now(),
        checkIns: [],
        isDaily: item.isDaily,
        weeklyGoal: item.weeklyGoal,
        currentStreak: 0,
        template: template.id,
      );
      await habitService.addHabit(habit);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${template.name} template applied! ✨'),
          backgroundColor: template.color,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}

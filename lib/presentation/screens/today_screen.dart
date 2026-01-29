import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../providers/habit_provider.dart';
import '../../features/habits/presentation/widgets/habit_list_item.dart';
import '../../services/aura_score_service.dart';
import '../../presentation/widgets/aura_score_ring.dart';
import 'add_edit_habit_screen.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayHabits = ref.watch(todayHabitsProvider);
    final allHabits = ref.watch(habitsListProvider);
    final auraScore = AuraScoreService.calculateAuraScore(allHabits);
    final habitService = ref.read(habitServiceProvider);

    return Scaffold(
      body: todayHabits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuraScoreRing(score: auraScore, size: 150),
                  const Gap(24),
                  Text(
                    'All caught up! 🎉',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Gap(8),
                  Text(
                    'No habits due today',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                // Header with Aura Score
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        AuraScoreRing(score: auraScore, size: 150),
                        const Gap(16),
                        Text(
                          'Today\'s Focus',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Gap(8),
                        Text(
                          '${todayHabits.length} ${todayHabits.length == 1 ? 'habit' : 'habits'} to complete',
                          style: Theme.of(context).textTheme.bodyMedium,
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
                        final habit = todayHabits[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: HabitListItem(
                            habit: habit,
                            onToggle: () async {
                              await habitService.toggleCheckIn(habit);
                            },
                          ),
                        );
                      },
                      childCount: todayHabits.length,
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


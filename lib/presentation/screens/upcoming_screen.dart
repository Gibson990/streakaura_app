import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../providers/habit_provider.dart';
import '../../features/habits/presentation/widgets/habit_list_item.dart';
import 'add_edit_habit_screen.dart';

class UpcomingScreen extends ConsumerWidget {
  const UpcomingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingHabits = ref.watch(upcomingHabitsProvider);
    final habitService = ref.read(habitServiceProvider);

    if (upcomingHabits.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 64,
                color: Colors.white54,
              ),
              const Gap(16),
              Text(
                'No upcoming habits',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Gap(8),
              Text(
                'Habits with due dates will appear here',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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

    // Group habits by date
    final groupedHabits = <DateTime, List<dynamic>>{};
    for (final habit in upcomingHabits) {
      if (habit.dueDate != null) {
        final dateKey = DateTime(
          habit.dueDate!.year,
          habit.dueDate!.month,
          habit.dueDate!.day,
        );
        groupedHabits.putIfAbsent(dateKey, () => []).add(habit);
      }
    }

    final sortedDates = groupedHabits.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          final date = sortedDates[index];
          final habits = groupedHabits[date]!;
          final isToday = date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;
          final isTomorrow = date.year == DateTime.now().add(const Duration(days: 1)).year &&
              date.month == DateTime.now().add(const Duration(days: 1)).month &&
              date.day == DateTime.now().add(const Duration(days: 1)).day;

          String dateLabel;
          if (isToday) {
            dateLabel = 'Today';
          } else if (isTomorrow) {
            dateLabel = 'Tomorrow';
          } else {
            dateLabel = DateFormat('EEEE, MMMM d').format(date);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              ...habits.map((habit) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: HabitListItem(
                      habit: habit as dynamic,
                      onToggle: () async {
                        await habitService.toggleCheckIn(habit);
                      },
                    ),
                  )),
              if (index < sortedDates.length - 1) const Gap(24),
            ],
          );
        },
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


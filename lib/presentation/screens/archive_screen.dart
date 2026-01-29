import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/habit_provider.dart';

class ArchiveScreen extends ConsumerWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final archivedHabits = ref.watch(archivedHabitsProvider);
    final habitService = ref.read(habitServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archive'),
      ),
      body: archivedHabits.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    size: 64,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Archive is empty',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Completed habits will appear here',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: archivedHabits.length,
              itemBuilder: (context, index) {
                final habit = archivedHabits[index];
                return Card(
                  child: ListTile(
                    leading: Text(
                      habit.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    title: Text(habit.name),
                    subtitle: habit.completedAt != null
                        ? Text(
                            'Completed: ${DateFormat('MMM d, yyyy').format(habit.completedAt!)}',
                          )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.unarchive),
                      onPressed: () async {
                        await habitService.unarchiveHabit(habit.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${habit.name} restored'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}


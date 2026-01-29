import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';
import '../../providers/tag_provider.dart';
import '../../providers/habit_provider.dart';
import '../../data/models/tag_model.dart';
import '../../features/habits/presentation/widgets/habit_list_item.dart';

class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsListProvider);
    final tagService = ref.read(tagServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTagDialog(context, ref),
          ),
        ],
      ),
      body: tags.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.label_outline,
                    size: 64,
                    color: Colors.white54,
                  ),
                  const Gap(16),
                  Text(
                    'No tags yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Gap(8),
                  Text(
                    'Create tags to categorize your habits',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: tags.map((tag) => _TagCard(
                    tag: tag,
                    onTap: () => _showTagDetails(context, ref, tag),
                    onEdit: () => _showEditTagDialog(context, ref, tag),
                    onDelete: () => tagService.deleteTag(tag.id),
                  )).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTagDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTagDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Tag'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tag Name',
                  hintText: 'Work, Health, Personal...',
                ),
              ),
              const Gap(16),
              Text(
                'Color',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Gap(8),
              Wrap(
                spacing: 8,
                children: [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                  Colors.pink,
                ].map((color) => GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    )).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final tag = Tag(
                    id: const Uuid().v4(),
                    name: nameController.text.trim(),
                    colorValue: selectedColor.value,
                    createdAt: DateTime.now(),
                  );
                  ref.read(tagServiceProvider).addTag(tag);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTagDialog(BuildContext context, WidgetRef ref, Tag tag) {
    final nameController = TextEditingController(text: tag.name);
    Color selectedColor = tag.color;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Tag'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Tag Name',
                ),
              ),
              const Gap(16),
              Text(
                'Color',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Gap(8),
              Wrap(
                spacing: 8,
                children: [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                  Colors.pink,
                ].map((color) => GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedColor == color
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    )).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  tag.name = nameController.text.trim();
                  tag.colorValue = selectedColor.value;
                  ref.read(tagServiceProvider).updateTag(tag);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTagDetails(BuildContext context, WidgetRef ref, Tag tag) {
    final habits = ref.watch(habitsByTagProvider(tag.id));
    final habitService = ref.read(habitServiceProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: tag.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      tag.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: habits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No habits with this tag',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: HabitListItem(
                            habit: habit,
                            onToggle: () async {
                              await habitService.toggleCheckIn(habit);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TagCard extends StatelessWidget {
  final Tag tag;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TagCard({
    required this.tag,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: tag.color,
            shape: BoxShape.circle,
          ),
        ),
        title: Text(tag.name),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Edit'),
              onTap: onEdit,
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              onTap: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}


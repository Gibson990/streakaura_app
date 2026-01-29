import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/tag_provider.dart';
import '../../data/models/tag_model.dart';

class TagSelector extends ConsumerWidget {
  final List<String> selectedTagIds;
  final Function(List<String>) onTagsChanged;

  const TagSelector({
    super.key,
    required this.selectedTagIds,
    required this.onTagsChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsListProvider);

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.label_outline, color: Colors.white70),
            title: const Text('Tags'),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () => _showTagPicker(context, ref, tags),
          ),
          if (selectedTagIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Wrap(
                spacing: 8,
                children: selectedTagIds.map((tagId) {
                  final tag = tags.firstWhere((t) => t.id == tagId);
                  return Chip(
                    label: Text(tag.name),
                    backgroundColor: tag.color.withOpacity(0.2),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      final updated = List<String>.from(selectedTagIds)..remove(tagId);
                      onTagsChanged(updated);
                    },
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _showTagPicker(
    BuildContext context,
    WidgetRef ref,
    List<Tag> tags,
  ) {
    final tempSelected = List<String>.from(selectedTagIds);

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Select Tags',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onTagsChanged(tempSelected);
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
            ),
            Flexible(
              child: tags.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No tags available. Create tags first.'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        final tag = tags[index];
                        final isSelected = tempSelected.contains(tag.id);
                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                tempSelected.add(tag.id);
                              } else {
                                tempSelected.remove(tag.id);
                              }
                            });
                          },
                          title: Text(tag.name),
                          secondary: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: tag.color,
                              shape: BoxShape.circle,
                            ),
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


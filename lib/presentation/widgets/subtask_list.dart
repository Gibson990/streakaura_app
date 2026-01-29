import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/subtask_model.dart';

class SubtaskList extends StatefulWidget {
  final List<Subtask> subtasks;
  final Function(List<Subtask>) onSubtasksChanged;

  const SubtaskList({
    super.key,
    required this.subtasks,
    required this.onSubtasksChanged,
  });

  @override
  State<SubtaskList> createState() => _SubtaskListState();
}

class _SubtaskListState extends State<SubtaskList> {
  late List<Subtask> _subtasks;

  @override
  void initState() {
    super.initState();
    _subtasks = List.from(widget.subtasks);
  }

  void _addSubtask() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Subtask name',
            hintText: 'e.g., Warm up, Stretch, Cool down',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _subtasks.add(Subtask(
                    id: const Uuid().v4(),
                    title: controller.text.trim(),
                    createdAt: DateTime.now(),
                  ));
                });
                widget.onSubtasksChanged(_subtasks);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _toggleSubtask(int index) {
    setState(() {
      _subtasks[index].isCompleted = !_subtasks[index].isCompleted;
    });
    widget.onSubtasksChanged(_subtasks);
  }

  void _deleteSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
    widget.onSubtasksChanged(_subtasks);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.checklist, color: Colors.white70),
            title: const Text('Subtasks'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addSubtask,
            ),
          ),
          if (_subtasks.isNotEmpty)
            ..._subtasks.asMap().entries.map((entry) {
              final index = entry.key;
              final subtask = entry.value;
              return CheckboxListTile(
                value: subtask.isCompleted,
                onChanged: (_) => _toggleSubtask(index),
                title: Text(
                  subtask.title,
                  style: subtask.isCompleted
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
                secondary: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => _deleteSubtask(index),
                ),
              );
            }),
        ],
      ),
    );
  }
}


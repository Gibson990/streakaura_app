import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../data/models/habit_model.dart';
import '../../providers/habit_provider.dart';
import '../../features/pro/premium_gate.dart';
import '../../services/notification_service.dart';
import 'paywall_screen.dart';

class AddEditHabitScreen extends ConsumerStatefulWidget {
  const AddEditHabitScreen({super.key, this.habit});

  final Habit? habit;

  @override
  ConsumerState<AddEditHabitScreen> createState() => _AddEditHabitScreenState();
}

class _AddEditHabitScreenState extends ConsumerState<AddEditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emojiController = TextEditingController(
    text: '✨',
  );
  final TextEditingController _descController = TextEditingController();
  bool _isDaily = true;
  int _weeklyGoal = 7;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    final habit = widget.habit;
    if (habit != null) {
      _nameController.text = habit.name;
      _emojiController.text = habit.emoji;
      _descController.text = habit.description ?? '';
      _isDaily = habit.isDaily;
      _weeklyGoal = habit.weeklyGoal;
      _reminderTime = habit.reminderTime;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final habitService = ref.read(habitServiceProvider);
    final habits = ref.read(habitsListProvider);
    if (!PremiumGate.isPremium &&
        habits.length >= AppConstants.freeHabitLimit &&
        widget.habit == null) {
      if (mounted) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Premium required'),
            content: Text(
              'Free plan allows ${AppConstants.freeHabitLimit} habits. Upgrade to add more.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Not now'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PaywallScreen()),
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
    final isEditing = widget.habit != null;

    if (isEditing) {
      // Update existing habit
      final habit = widget.habit!
        ..name = _nameController.text.trim()
        ..emoji = _emojiController.text.trim().isEmpty
            ? '✨'
            : _emojiController.text.trim()
        ..description = _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim()
        ..isDaily = _isDaily
        ..weeklyGoal = _weeklyGoal
        ..reminderTime = _reminderTime;

      await habitService.addHabit(habit);

      // Cancel old notification and schedule new one if time changed
      if (habit.reminderTime != null) {
        await NotificationService.instance.cancelReminder(habit.id.hashCode);
        await NotificationService.instance.scheduleHabitReminder(
          id: habit.id.hashCode,
          habitName: habit.name,
          emoji: habit.emoji,
          hour: habit.reminderTime!.hour,
          minute: habit.reminderTime!.minute,
        );
      } else {
        // Cancel notification if reminder was removed
        await NotificationService.instance.cancelReminder(habit.id.hashCode);
      }
    } else {
      // Create new habit
      final habit = Habit(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        emoji: _emojiController.text.trim().isEmpty
            ? '✨'
            : _emojiController.text.trim(),
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        createdAt: DateTime.now(),
        checkIns: [],
        isDaily: _isDaily,
        weeklyGoal: _weeklyGoal,
        currentStreak: 0,
        template: 'custom',
        reminderTime: _reminderTime,
      );

      await habitService.addHabit(habit);

      // Schedule notification if reminder time is set
      if (habit.reminderTime != null) {
        await NotificationService.instance.scheduleHabitReminder(
          id: habit.id.hashCode,
          habitName: habit.name,
          emoji: habit.emoji,
          hour: habit.reminderTime!.hour,
          minute: habit.reminderTime!.minute,
        );
      }
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'Add Habit' : 'Edit Habit'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create something to keep glowing ✨',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Gap(16),
                TextFormField(
                  controller: _nameController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Habit name',
                    hintText: 'Read 20 mins',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Enter a habit name'
                      : null,
                ),
                const Gap(12),
                TextFormField(
                  controller: _emojiController,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: 24),
                  decoration: const InputDecoration(
                    labelText: 'Emoji',
                    hintText: '📚',
                  ),
                  maxLength: 2,
                ),
                const Gap(12),
                TextFormField(
                  controller: _descController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Short note',
                  ),
                  maxLines: 2,
                ),
                const Gap(12),
                Text(
                  'Schedule',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Gap(8),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('Daily')),
                    ButtonSegment(value: false, label: Text('Weekly')),
                  ],
                  selected: {_isDaily},
                  onSelectionChanged: (selection) {
                    setState(() => _isDaily = selection.first);
                  },
                ),
                if (!_isDaily) ...[
                  const Gap(12),
                  DropdownMenu<int>(
                    label: const Text('Weekly goal'),
                    initialSelection: _weeklyGoal,
                    onSelected: (value) {
                      if (value != null) {
                        setState(() => _weeklyGoal = value);
                      }
                    },
                    dropdownMenuEntries: List.generate(
                      7,
                      (index) => DropdownMenuEntry(
                        value: index + 1,
                        label: '${index + 1} times per week',
                      ),
                    ),
                  ),
                ],
                const Gap(16),
                // Reminder Time Picker
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Reminder Time'),
                    subtitle: Text(
                      _reminderTime != null
                          ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
                          : 'No reminder set',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: _reminderTime != null
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                            ),
                            onPressed: () => setState(() {
                              _reminderTime = null;
                            }),
                          )
                        : null,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _reminderTime ?? TimeOfDay.now(),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: Theme.of(context)
                                .colorScheme
                                .copyWith(secondary: AppConstants.accentTeal),
                          ),
                          child: child!,
                        ),
                      );
                      if (time != null && mounted) {
                        setState(() {
                          _reminderTime = time;
                        });
                      }
                    },
                  ),
                ),
                const Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppConstants.accentTeal,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      widget.habit == null ? 'Add Habit' : 'Save Changes',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

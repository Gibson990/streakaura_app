import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../data/models/habit_model.dart';
import '../../../../../core/constants/app_constants.dart';

class HabitListItem extends StatefulWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const HabitListItem({
    super.key,
    required this.habit,
    required this.onToggle,
  });

  @override
  State<HabitListItem> createState() => _HabitListItemState();
}

class _HabitListItemState extends State<HabitListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _rippleController.forward(from: 0);
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = widget.habit.checkIns.any((d) => 
      d.year == DateTime.now().year && d.month == DateTime.now().month && d.day == DateTime.now().day
    );

    // Recalculate streak for display
    widget.habit.calculateCurrentStreak();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Emoji and Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.habit.emoji} ${widget.habit.name}',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const Gap(4),
                  Text(
                    'Current Streak: ${widget.habit.currentStreak} days 🔥',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Longest: ${widget.habit.longestStreak} days',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            
            // Check-in Button with Ripple
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripple effect
                    if (_rippleAnimation.value > 0)
                      Container(
                        width: 50 + (_rippleAnimation.value * 30),
                        height: 50 + (_rippleAnimation.value * 30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppConstants.accentTeal
                              .withOpacity(0.3 * (1 - _rippleAnimation.value)),
                        ),
                      ),
                    // Button
                    GestureDetector(
                      onTap: _handleTap,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isCheckedIn
                              ? AppConstants.accentTeal
                              : Theme.of(context).colorScheme.surfaceVariant,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCheckedIn
                                ? Colors.transparent
                                : Theme.of(context).colorScheme.outline,
                            width: 2,
                          ),
                          boxShadow: isCheckedIn
                              ? [
                                  BoxShadow(
                                    color: AppConstants.accentTeal.withOpacity(0.5),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: isCheckedIn
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 30)
                            : Icon(Icons.add,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                size: 30),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

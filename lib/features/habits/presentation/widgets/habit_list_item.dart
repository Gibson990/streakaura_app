import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../data/models/habit_model.dart';

class HabitListItem extends StatefulWidget {
  final Habit habit;
  final VoidCallback onToggle;

  const HabitListItem({super.key, required this.habit, required this.onToggle});

  @override
  State<HabitListItem> createState() => _HabitListItemState();
}

class _HabitListItemState extends State<HabitListItem>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late ConfettiController _confettiController;

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
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.94, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _confettiController = ConfettiController(
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _pulseController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _handleTap(bool isAlreadyCheckedIn) {
    _rippleController.forward(from: 0);
    HapticFeedback.lightImpact();
    if (!isAlreadyCheckedIn) {
      _confettiController.play();
    }
    widget.onToggle();

    if (!isAlreadyCheckedIn && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text(
              'Glow streak +1! Tap undo if that was accidental.',
            ),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                widget.onToggle();
              },
            ),
            duration: const Duration(seconds: 3),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCheckedIn = widget.habit.checkIns.any(
      (d) =>
          d.year == DateTime.now().year &&
          d.month == DateTime.now().month &&
          d.day == DateTime.now().day,
    );

    // Recalculate streak for display
    widget.habit.calculateCurrentStreak();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final streak = widget.habit.currentStreak;
    final longestStreak = widget.habit.longestStreak;
    final reminder = widget.habit.reminderTime;
    final reminderLabel = reminder != null
        ? MaterialLocalizations.of(context).formatTimeOfDay(reminder)
        : null;
    final nextMilestone = _nextMilestone(streak);
    final milestoneProgress = nextMilestone == 0
        ? 1.0
        : (streak / nextMilestone).clamp(0.0, 1.0);
    final milestoneCaption = streak >= nextMilestone
        ? 'Milestone reached! 🎉'
        : '${(nextMilestone - streak).clamp(0, nextMilestone)} to ${_milestoneName(nextMilestone)}';
    final streakCompanion = _companionForStreak(streak);
    final buttonScale = isCheckedIn ? 1.0 : _pulseAnimation.value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isCheckedIn
                      ? [
                          AppConstants.accentTeal.withValues(alpha: 0.35),
                          AppConstants.primaryIndigo.withValues(alpha: 0.25),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.94),
                          AppConstants.surfaceMuted.withValues(alpha: 0.8),
                        ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.35),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isCheckedIn
                                ? AppConstants.accentTeal
                                : AppConstants.primaryIndigo)
                            .withValues(alpha: 0.16),
                    blurRadius: 38,
                    spreadRadius: 2,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                                child: Text(
                                  widget.habit.emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                              const Gap(14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.habit.name,
                                      style: textTheme.displayMedium?.copyWith(
                                        color: isCheckedIn
                                            ? Colors.white
                                            : theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      'Daily glow companion',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.22),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Text(
                                  streakCompanion,
                                  style: const TextStyle(fontSize: 22),
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),
                          Text(
                            'Glow streak • $milestoneCaption',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              minHeight: 10,
                              value: milestoneProgress,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.18,
                              ),
                              valueColor: AlwaysStoppedAnimation(
                                isCheckedIn
                                    ? Colors.white
                                    : AppConstants.accentTeal.withValues(
                                        alpha: 0.8,
                                      ),
                              ),
                            ),
                          ),
                          const Gap(18),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _glowPill(
                                context,
                                '${math.max(streak, 0)} day streak',
                                emoji: '🔥',
                              ),
                              _glowPill(
                                context,
                                'Longest $longestStreak',
                                emoji: '🏅',
                              ),
                              _glowPill(
                                context,
                                widget.habit.isDaily
                                    ? 'Daily glow'
                                    : '${widget.habit.weeklyGoal}x / week',
                                emoji: widget.habit.isDaily ? '🌞' : '📆',
                              ),
                              if (reminderLabel != null)
                                _glowPill(
                                  context,
                                  'Reminder $reminderLabel',
                                  icon: Icons.alarm_rounded,
                                ),
                              if (reminderLabel == null)
                                _glowPill(
                                  context,
                                  'Add a reminder',
                                  icon: Icons.add_alert_rounded,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(18),
                    _buildCheckButton(isCheckedIn, buttonScale),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 140,
                  height: double.infinity,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    emissionFrequency: 0.02,
                    numberOfParticles: 16,
                    gravity: 0.2,
                    minBlastForce: 6,
                    maxBlastForce: 18,
                    colors: const [
                      Colors.white,
                      AppConstants.accentTeal,
                      AppConstants.primaryIndigo,
                      Color(0xFFFF8FA2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckButton(bool isCheckedIn, double scale) {
    return GestureDetector(
      onTap: () => _handleTap(isCheckedIn),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_rippleAnimation.value > 0)
            Container(
              width: 78 + (_rippleAnimation.value * 24),
              height: 78 + (_rippleAnimation.value * 24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isCheckedIn ? AppConstants.accentTeal : Colors.white)
                    .withValues(alpha: 0.16 * (1 - _rippleAnimation.value)),
              ),
            ),
          Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isCheckedIn
                    ? const LinearGradient(
                        colors: [Color(0xFF00D1FF), Color(0xFF5E17EB)],
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFFFFFFF), Color(0xFFDCE6FF)],
                      ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isCheckedIn
                                ? AppConstants.accentTeal
                                : AppConstants.primaryIndigo)
                            .withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isCheckedIn)
                    const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 30,
                    )
                  else
                    const Icon(
                      Icons.auto_fix_high,
                      color: Color(0xFF5E17EB),
                      size: 28,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    isCheckedIn ? 'Glowing' : 'Glow',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isCheckedIn
                          ? Colors.white
                          : const Color(0xFF5E17EB),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowPill(
    BuildContext context,
    String label, {
    String? emoji,
    IconData? icon,
  }) {
    final textStyle =
        Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ) ??
        const TextStyle(color: Colors.white, fontWeight: FontWeight.w700);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null) Text(emoji, style: const TextStyle(fontSize: 16)),
          if (icon != null)
            Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.9)),
          if (emoji != null || icon != null) const Gap(6),
          Text(label, style: textStyle),
        ],
      ),
    );
  }

  int _nextMilestone(int streak) {
    if (streak < 7) return 7;
    if (streak < 30) return 30;
    if (streak < 100) return 100;
    if (streak < 365) return 365;
    return ((streak + 50) / 50).floor() * 50;
  }

  String _milestoneName(int milestone) {
    switch (milestone) {
      case 7:
        return 'Spark Badge';
      case 30:
        return 'Glow Badge';
      case 100:
        return 'Nova Badge';
      case 365:
        return 'Aurora Legend';
      default:
        return '$milestone-day badge';
    }
  }

  String _companionForStreak(int streak) {
    if (streak >= 100) return '🐉';
    if (streak >= 50) return '🦄';
    if (streak >= 30) return '🦊';
    if (streak >= 14) return '🦋';
    if (streak >= 7) return '🐱';
    if (streak >= 3) return '🐣';
    if (streak >= 1) return '🌼';
    return '🌱';
  }
}

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../core/constants/app_constants.dart';

class StreakMilestoneDialog extends StatefulWidget {
  final int streak;
  final String habitName;
  final String emoji;

  const StreakMilestoneDialog({
    super.key,
    required this.streak,
    required this.habitName,
    required this.emoji,
  });

  @override
  State<StreakMilestoneDialog> createState() => _StreakMilestoneDialogState();
}

class _StreakMilestoneDialogState extends State<StreakMilestoneDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // Play confetti when dialog appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _getMilestoneMessage() {
    if (widget.streak == 7) {
      return 'Week Warrior! 🔥';
    } else if (widget.streak == 30) {
      return 'Month Master! 🌟';
    } else if (widget.streak == 100) {
      return 'Century Club! 💎';
    }
    return 'Amazing Streak!';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppConstants.primaryIndigo, AppConstants.lavender],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.emoji, style: const TextStyle(fontSize: 80)),
                const SizedBox(height: 16),
                Text(
                  _getMilestoneMessage(),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.streak} Day Streak!',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.habitName} streak is on fire! 🔥',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.87),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppConstants.primaryIndigo,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Keep Going!'),
                ),
              ],
            ),
          ),
          // Confetti from top
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 1.5708, // 90 degrees (straight down)
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              colors: const [
                AppConstants.accentTeal,
                AppConstants.primaryIndigo,
                AppConstants.lavender,
                Colors.white,
                Colors.yellow,
              ],
            ),
          ),
          // Confetti from center
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                AppConstants.accentTeal,
                AppConstants.primaryIndigo,
                AppConstants.lavender,
                Colors.white,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

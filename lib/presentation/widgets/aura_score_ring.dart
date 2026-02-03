import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/constants/app_constants.dart';
import '../../services/aura_score_service.dart';

/// Liquid glass animated ring showing Aura Score
class AuraScoreRing extends StatefulWidget {
  final int score;
  final double size;

  const AuraScoreRing({
    super.key,
    required this.score,
    this.size = 200,
  });

  @override
  State<AuraScoreRing> createState() => _AuraScoreRingState();
}

class _AuraScoreRingState extends State<AuraScoreRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _animatedScore = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0,
      end: widget.score.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _animation.addListener(() {
      setState(() {
        _animatedScore = _animation.value;
      });
    });
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(AuraScoreRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(
        begin: _animatedScore,
        end: widget.score.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _animatedScore / 100;
    final strokeWidth = widget.size * 0.08;

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppConstants.primaryIndigo.withOpacity(0.18),
            Theme.of(context).colorScheme.background,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.surfaceVariant,
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Animated progress ring
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: Transform.rotate(
              angle: -math.pi / 2,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: strokeWidth,
                strokeCap: StrokeCap.round,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppConstants.accentTeal,
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_animatedScore.round()}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: widget.size * 0.25,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [
                            AppConstants.accentTeal,
                            AppConstants.lavender,
                          ],
                        ).createShader(
                          Rect.fromLTWH(0, 0, widget.size, widget.size),
                        ),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                AuraScoreService.getAuraLabel(widget.score),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: widget.size * 0.06,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

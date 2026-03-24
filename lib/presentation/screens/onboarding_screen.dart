import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final Set<String> _selectedGoalIds = <String>{};

  late final List<OnboardingSlide> _slides = [
    const OnboardingSlide.story(
      emoji: '✨',
      title: 'Add Your Habits',
      description:
          'Create habits that light up your life. Choose an emoji, set your goal, and start glowing.',
      gradient: [AppConstants.primaryIndigo, AppConstants.lavender],
    ),
    const OnboardingSlide.story(
      emoji: '🔥',
      title: 'Check In Daily',
      description:
          'One tap to check in. Watch your streaks grow and your Aura Score rise with every action.',
      gradient: [AppConstants.lavender, AppConstants.accentTeal],
    ),
    const OnboardingSlide.story(
      emoji: '🌟',
      title: 'Glow Up',
      description:
          'Build consistency, unlock badges, and see your daily glow transform into lasting change.',
      gradient: [AppConstants.accentTeal, AppConstants.primaryIndigo],
    ),
    OnboardingSlide.goalSelection(
      title: 'Choose Your Glow Goals',
      description:
          'Pick what you’d love to focus on first — we’ll tailor templates just for you.',
      gradient: const [AppConstants.primaryIndigo, AppConstants.accentTeal],
      goals: const [
        GlowGoal(
          id: 'energy',
          emoji: '⚡️',
          title: 'Morning Energy',
          subtitle: 'Own your AM routine',
        ),
        GlowGoal(
          id: 'focus',
          emoji: '🎯',
          title: 'Deep Focus',
          subtitle: 'Block distractions & flow',
        ),
        GlowGoal(
          id: 'wellness',
          emoji: '🧘',
          title: 'Mind & Body',
          subtitle: 'Move & breathe daily',
        ),
        GlowGoal(
          id: 'creator',
          emoji: '🎨',
          title: 'Creator Glow',
          subtitle: 'Ship your art & ideas',
        ),
        GlowGoal(
          id: 'relationships',
          emoji: '💞',
          title: 'Heart Habits',
          subtitle: 'Stay close to your people',
        ),
      ],
    ),
  ];

  bool get _isOnLastPage => _currentPage == _slides.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final settingsBox = Hive.box(AppConstants.settingsBox);
    await settingsBox.put('onboarding_completed', true);
    await settingsBox.put('glow_goals', _selectedGoalIds.toList());

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _nextPage() {
    if (_isOnLastPage) {
      _completeOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  void _skip() {
    _completeOnboarding();
  }

  void _toggleGoal(String id) {
    setState(() {
      if (_selectedGoalIds.contains(id)) {
        _selectedGoalIds.remove(id);
      } else {
        _selectedGoalIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentPage];
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: slide.gradient,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _AuroraGlow(currentPage: _currentPage),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 6,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: (_currentPage + 1) / _slides.length,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.white, Color(0xFFF1F5FF)],
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _skip,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _slides.length,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                        child: _OnboardingSlideView(
                          slide: _slides[index],
                          isActive: _currentPage == index,
                          selectedGoalIds: _selectedGoalIds,
                          onToggleGoal: _toggleGoal,
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: _currentPage == index ? 30 : 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            _currentPage == index ? 0.9 : 0.4,
                          ),
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: _currentPage == index
                              ? [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.45),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ),
                  const Gap(24),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: FilledButton(
                      onPressed: _isOnLastPage && _selectedGoalIds.isEmpty
                          ? () => _toggleGoal(_slides.last.goals!.first.id)
                          : _nextPage,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppConstants.primaryIndigo,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: Text(
                        _isOnLastPage
                            ? (_selectedGoalIds.isEmpty
                                  ? 'Surprise Me ✨'
                                  : 'Finish & Glow ✨')
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlideView extends StatelessWidget {
  const _OnboardingSlideView({
    required this.slide,
    required this.isActive,
    required this.selectedGoalIds,
    required this.onToggleGoal,
  });

  final OnboardingSlide slide;
  final bool isActive;
  final Set<String> selectedGoalIds;
  final ValueChanged<String> onToggleGoal;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeInExpo,
      child: slide.type == OnboardingSlideType.story
          ? _StorySlide(slide: slide)
          : _GoalSelectionSlide(
              slide: slide,
              selectedGoalIds: selectedGoalIds,
              onToggleGoal: onToggleGoal,
            ),
    );
  }
}

class _StorySlide extends StatelessWidget {
  const _StorySlide({required this.slide});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(slide.title),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.6),
              ],
            ),
          ),
          child: Text(slide.emoji ?? '', style: const TextStyle(fontSize: 88)),
        ),
        const Gap(36),
        Text(
          slide.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 0.4,
          ),
        ),
        const Gap(20),
        Text(
          slide.description ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 17,
            height: 1.6,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

class _GoalSelectionSlide extends StatelessWidget {
  const _GoalSelectionSlide({
    required this.slide,
    required this.selectedGoalIds,
    required this.onToggleGoal,
  });

  final OnboardingSlide slide;
  final Set<String> selectedGoalIds;
  final ValueChanged<String> onToggleGoal;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('goal_selection'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          slide.title,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(12),
        Text(
          slide.description ?? '',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
          ),
        ),
        const Gap(24),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final goal in slide.goals ?? <GlowGoal>[])
                  _GlowGoalChip(
                    goal: goal,
                    isSelected: selectedGoalIds.contains(goal.id),
                    onTap: () => onToggleGoal(goal.id),
                  ),
              ],
            ),
          ),
        ),
        const Gap(12),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: selectedGoalIds.isEmpty ? 1 : 0.7,
          child: Text(
            selectedGoalIds.isEmpty
                ? 'No worries — tap “Surprise Me” and we’ll curate a glow pack!'
                : 'Beautiful picks! We’ll load habits that match your glow goals.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowGoalChip extends StatelessWidget {
  const _GlowGoalChip({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  final GlowGoal goal;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(isSelected ? 0.28 : 0.12),
            border: Border.all(
              color: Colors.white.withOpacity(isSelected ? 0.9 : 0.3),
              width: isSelected ? 2.2 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.35),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(goal.emoji, style: const TextStyle(fontSize: 22)),
              const Gap(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    goal.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuroraGlow extends StatelessWidget {
  const _AuroraGlow({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: 0.45,
          child: Stack(
            children: [
              _floatingBubble(
                left: 40,
                top: 120,
                size: 160,
                delay: 0,
                page: currentPage,
              ),
              _floatingBubble(
                right: 28,
                top: 80,
                size: 100,
                delay: 200,
                page: currentPage,
              ),
              _floatingBubble(
                left: 30,
                bottom: 120,
                size: 140,
                delay: 350,
                page: currentPage,
              ),
              _floatingBubble(
                right: 60,
                bottom: 90,
                size: 110,
                delay: 500,
                page: currentPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floatingBubble({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required int delay,
    required int page,
  }) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 2200 + delay),
      curve: Curves.easeInOut,
      left: left != null ? left + (page.isEven ? 0 : 12) : null,
      right: right != null ? right + (page.isOdd ? 0 : -12) : null,
      top: top,
      bottom: bottom,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 1800 + delay),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.12),
              Colors.white.withOpacity(0.03),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.08),
              blurRadius: 40,
              spreadRadius: 12,
            ),
          ],
        ),
      ),
    );
  }
}

enum OnboardingSlideType { story, goal }

class OnboardingSlide {
  const OnboardingSlide._({
    required this.type,
    required this.gradient,
    this.emoji,
    this.title = '',
    this.description,
    this.goals,
  });

  const OnboardingSlide.story({
    required String emoji,
    required String title,
    required String description,
    required List<Color> gradient,
  }) : this._(
         type: OnboardingSlideType.story,
         emoji: emoji,
         title: title,
         description: description,
         gradient: gradient,
       );

  OnboardingSlide.goalSelection({
    required String title,
    required String description,
    required List<Color> gradient,
    required List<GlowGoal> goals,
  }) : this._(
         type: OnboardingSlideType.goal,
         title: title,
         description: description,
         gradient: gradient,
         goals: goals,
       );

  final OnboardingSlideType type;
  final String? emoji;
  final String title;
  final String? description;
  final List<Color> gradient;
  final List<GlowGoal>? goals;
}

class GlowGoal {
  const GlowGoal({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String id;
  final String emoji;
  final String title;
  final String subtitle;
}

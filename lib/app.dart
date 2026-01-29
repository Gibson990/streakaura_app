import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/onboarding_screen.dart';

class StreakAuraApp extends StatelessWidget {
  const StreakAuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return MaterialApp(
      title: 'StreakAura',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    // Check if user has completed onboarding
    final settingsBox = Hive.box(AppConstants.settingsBox);
    final hasCompletedOnboarding = settingsBox.get('onboarding_completed', defaultValue: false) as bool;
    
    if (hasCompletedOnboarding) {
      return const MainNavigationScreen();
    } else {
      return const OnboardingScreen();
    }
  }
}

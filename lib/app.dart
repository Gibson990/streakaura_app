import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/auth_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/habit_provider.dart';

class StreakAuraApp extends ConsumerWidget {
  const StreakAuraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'StreakAura',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: _getInitialScreen(ref),
    );
  }

  Widget _getInitialScreen(WidgetRef ref) {
    // Check if user has completed onboarding
    final settingsBox = Hive.box(AppConstants.settingsBox);
    final hasCompletedOnboarding =
        settingsBox.get('onboarding_completed', defaultValue: false) as bool;

    if (hasCompletedOnboarding) {
      final authState = ref.watch(authStateProvider);
      return authState.when(
        data: (uid) => uid == null ? const AuthScreen() : const HomeScreen(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const AuthScreen(),
      );
    } else {
      return const OnboardingScreen();
    }
  }
}

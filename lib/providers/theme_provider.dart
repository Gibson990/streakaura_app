import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(_loadInitialThemeMode());

  static const _themeModeKey = 'theme_mode';

  static ThemeMode _loadInitialThemeMode() {
    final settingsBox = Hive.box(AppConstants.settingsBox);
    final storedValue = settingsBox.get(_themeModeKey) as String?;

    if (storedValue == null) {
      return ThemeMode.system;
    }

    return ThemeMode.values.firstWhere(
      (mode) => mode.name == storedValue,
      orElse: () => ThemeMode.system,
    );
  }

  void setThemeMode(ThemeMode mode) {
    if (state == mode) return;

    final settingsBox = Hive.box(AppConstants.settingsBox);
    settingsBox.put(_themeModeKey, mode.name);
    state = mode;
  }

  void toggleDarkMode(bool isDark) {
    setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}

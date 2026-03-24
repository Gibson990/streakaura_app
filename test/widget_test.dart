import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:streakaura_app/app.dart';
import 'package:streakaura_app/core/constants/app_constants.dart';
import 'package:streakaura_app/data/models/habit_model.dart';
import 'package:streakaura_app/services/sound_service.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp('streakaura_widget_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }
    await Hive.openBox<Habit>(AppConstants.habitsBox);
    final settingsBox = await Hive.openBox(AppConstants.settingsBox);
    await settingsBox.put('onboarding_completed', true);
    SoundService.configure(enabled: false);
  });

  tearDownAll(() async {
    await Hive.box(AppConstants.settingsBox).close();
    await Hive.box<Habit>(AppConstants.habitsBox).close();
    await Hive.deleteBoxFromDisk(AppConstants.settingsBox);
    await Hive.deleteBoxFromDisk(AppConstants.habitsBox);
    await tempDir.delete(recursive: true);
  });

  testWidgets('StreakAura app launches successfully', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: StreakAuraApp()));
    await tester.pumpAndSettle();

    // Verify home screen empty state renders
    expect(find.text('No habits yet. Tap + to add one!'), findsOneWidget);
  });
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:streakaura_app/core/constants/app_constants.dart';
import 'package:streakaura_app/data/models/habit_model.dart';
import 'package:streakaura_app/presentation/screens/home_screen.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('streakaura_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HabitAdapter());
    }
    await Hive.openBox<Habit>(AppConstants.habitsBox);
  });

  tearDownAll(() async {
    await Hive.deleteBoxFromDisk(AppConstants.habitsBox);
    await tempDir.delete(recursive: true);
  });

  testWidgets('HomeScreen displays empty state when no habits', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );

    expect(find.text('No habits yet. Tap + to add one!'), findsOneWidget);
    expect(find.text('Your Daily Glow, One Streak at a Time'), findsOneWidget);
  });

  testWidgets('HomeScreen has floating action button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('HomeScreen has settings button in app bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomeScreen())),
    );

    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}

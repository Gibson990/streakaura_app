import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streakaura_app/presentation/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays empty state when no habits', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.text('No habits yet. Tap + to add one!'), findsOneWidget);
    expect(find.text('Your Daily Glow, One Streak at a Time'), findsOneWidget);
  });

  testWidgets('HomeScreen has floating action button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('HomeScreen has settings button in app bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}


import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:streakaura_app/app.dart';

void main() {
  testWidgets('StreakAura app launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: StreakAuraApp(),
      ),
    );

    // Verify app title is present
    expect(find.text('StreakAura'), findsWidgets);
  });
}

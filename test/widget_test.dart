import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ape_archive/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ApeArchiveApp()));

    // Verify that the app loads successfully
    expect(find.text('Welcome to Ape Archive'), findsOneWidget);
  });
}

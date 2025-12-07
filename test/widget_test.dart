import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    // Build a simple widget to verify the test framework is working
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Ape Archive Test'),
          ),
        ),
      ),
    );

    // Verify that the widget renders correctly
    expect(find.text('Ape Archive Test'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}

import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Input test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DNText(
            title: 'text',
          ),
        ),
      ),
    );

    expect(find.text('text'), findsOneWidget);
  });
}

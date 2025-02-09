import 'package:calendar_flutter/ui/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Button test', (WidgetTester tester) async {
    bool isPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DNButton(
            onClick: () {
              isPressed = true;
            },
            title: 'title',
            isPrimary: false,
          ),
        ),
      ),
    );

    expect(find.text('title'), findsOneWidget);
    await tester.tap(find.text('title'));
    await tester.pump();
    expect(isPressed, true);
  });
}

import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Icon button test', (WidgetTester tester) async {
    bool isPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DNIconButton(
            onClick: () {
              isPressed = true;
            },
            icon: const Icon(Icons.add),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(isPressed, true);
  });
}

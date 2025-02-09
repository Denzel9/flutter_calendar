import 'package:calendar_flutter/ui/components/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Input test', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DNInput(
            title: 'input',
            controller: controller,
          ),
        ),
      ),
    );

    expect(find.byType(DNInput), findsOneWidget);
    await tester.enterText(find.byType(DNInput), 'Text');
    expect(controller.text, 'Text');
  });
}

import 'package:calendar_flutter/ui/components/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  testWidgets('CachedNetworkImage displays image on successful load',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DNImage(
            url:
                'https://images.wallpaperscraft.com/image/single/lake_mountain_tree_36589_2650x1600.jpg',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(CachedNetworkImage), findsOneWidget);
  });
}

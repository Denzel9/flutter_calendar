import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final String title;

  const EmptyList({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.featured_play_list_outlined,
            size: 100, color: Colors.white54),
        DNText(
          title: title,
          opacity: .5,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}

import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';

class DNBadge extends StatelessWidget {
  final String? title;
  final Widget? icon;
  final Color backgroundColor;

  const DNBadge({
    super.key,
    this.title,
    this.backgroundColor = Colors.green,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => Badge(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        backgroundColor: backgroundColor,
        label: icon ??
            DNText(
              title: title ?? '',
              fontSize: 14,
            ),
      );
}

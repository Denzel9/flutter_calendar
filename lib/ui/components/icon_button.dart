import 'package:flutter/material.dart';

class DNIconButton extends StatelessWidget {
  final Widget icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClick;

  const DNIconButton({
    super.key,
    required this.icon,
    required this.onClick,
    this.backgroundColor = Colors.amberAccent,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onClick,
        icon: icon,
        color: color,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(backgroundColor),
        ),
      );
}

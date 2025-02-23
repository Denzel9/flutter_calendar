import 'package:flutter/material.dart';

class DNText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final double opacity;
  final Color color;

  const DNText({
    required this.title,
    super.key,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.height = 1,
    this.color = Colors.white,
    this.opacity = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: color.withAlpha((opacity * 255).toInt()),
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        overflow: TextOverflow.clip,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DNInput extends StatelessWidget {
  final String title;
  final Function(String string)? onClick;

  final TextEditingController? controller;

  final bool withBoarder;

  final Color borderColor;

  final double fontSize;
  final double opacity;

  final int countLines;

  final FontWeight fontWeight;

  const DNInput({
    super.key,
    required this.title,
    this.onClick,
    this.withBoarder = true,
    this.borderColor = Colors.white,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.opacity = 1,
    this.countLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onClick,
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.amberAccent,
      minLines: countLines,
      maxLines: countLines,
      decoration: InputDecoration(
        label: Text(
          title,
          style: TextStyle(
            fontSize: 25,
            fontWeight: fontWeight,
            color: Colors.white.withOpacity(.5),
            height: .5,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              withBoarder ? BorderSide(color: borderColor) : BorderSide.none,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              withBoarder ? BorderSide(color: borderColor) : BorderSide.none,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DNInput extends StatelessWidget {
  final String title;
  final Function(String string)? onSubmitted;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool withBoarder;
  final bool autoFocus;
  final Color borderColor;
  final double fontSize;
  final double opacity;
  final int countLines;
  final FontWeight fontWeight;
  final FocusNode? focusNode;

  const DNInput({
    super.key,
    required this.title,
    this.withBoarder = true,
    this.borderColor = Colors.white,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.opacity = 1,
    this.countLines = 1,
    this.controller,
    this.focusNode,
    this.autoFocus = false,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) => TextField(
        autofocus: autoFocus,
        textInputAction: TextInputAction.done,
        focusNode: focusNode,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.amberAccent,
        minLines: countLines,
        maxLines: countLines,
        decoration: InputDecoration(
          label: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: fontWeight,
              color: Colors.white54,
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

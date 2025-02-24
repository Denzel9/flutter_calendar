import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';

class DNButton extends StatelessWidget {
  final String title;
  final VoidCallback onClick;
  final bool isPrimary;
  final double width;
  final double height;
  final double fontSize;
  final Color color;
  final bool loading;

  const DNButton({
    super.key,
    required this.title,
    required this.onClick,
    required this.isPrimary,
    this.loading = false,
    this.width = 100,
    this.height = 45,
    this.fontSize = 16,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onClick,
        child: AnimatedContainer(
          width: width,
          height: height,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isPrimary
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                color: isPrimary ? Colors.transparent : Colors.white),
          ),
          child: Align(
            alignment: Alignment.center,
            child: loading
                ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                : DNText(
                    title: title,
                    fontSize: fontSize,
                    color: isPrimary ? color : Colors.white,
                  ),
          ),
        ),
      );
}

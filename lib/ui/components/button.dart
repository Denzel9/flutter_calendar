import 'package:flutter/material.dart';

class DNButton extends StatelessWidget {
  final String title;
  final void Function() onClick;
  final bool isPrimary;

  final double width;
  final double height;
  final double fonySize;

  final Color? backgroundColor;
  final Color color;

  final bool loading;

  const DNButton({
    super.key,
    required this.title,
    required this.onClick,
    required this.isPrimary,
    this.loading = false,
    this.width = 100,
    this.height = 40,
    this.fonySize = 18,
    this.backgroundColor,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      splashColor: Colors.white10,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Ink(
        padding: loading
            ? const EdgeInsets.symmetric(horizontal: 30, vertical: 5)
            : null,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Theme.of(context).primaryColor,
          image: isPrimary
              ? DecorationImage(
                  image: const AssetImage('assets/pattern.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.amberAccent.shade200,
                    BlendMode.multiply,
                  ),
                )
              : null,
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                )
              : Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: fonySize,
                      fontWeight: FontWeight.w400,
                      color: isPrimary ? color : Colors.black,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

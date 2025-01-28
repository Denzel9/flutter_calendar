import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SlideAnimation extends StatelessWidget {
  final Widget widget;
  final Offset? begin;
  final Offset? end;
  final Duration? duration;
  final Duration? delay;
  final Curve? curve;
  final bool? target;

  const SlideAnimation({
    super.key,
    required this.widget,
    this.begin = const Offset(1, 0),
    this.end = const Offset(0, 0),
    this.duration = const Duration(milliseconds: 500),
    this.delay = const Duration(milliseconds: 0),
    this.curve = Curves.easeInOut,
    this.target,
  });

  @override
  Widget build(BuildContext context) {
    return widget
        .animate(
            target: target != null
                ? target!
                    ? 1
                    : 0
                : null)
        .slide(
          curve: curve,
          delay: delay,
          begin: begin,
          end: end,
          duration: duration,
        );
  }
}

import 'package:calendar_flutter/ui/views/create/ui/assign.dart';
import 'package:calendar_flutter/ui/views/create/ui/info.dart';
import 'package:calendar_flutter/ui/views/create/ui/media.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class DNForm extends StatelessWidget {
  final bool isTask;
  const DNForm({super.key, required this.isTask});

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Info(isTask: isTask), const Assign(), const Media()],
      ),
    );
  }
}

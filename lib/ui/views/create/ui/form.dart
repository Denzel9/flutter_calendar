import 'package:calendar_flutter/ui/views/create/ui/assign.dart';
import 'package:calendar_flutter/ui/views/create/ui/info.dart';
import 'package:calendar_flutter/ui/views/create/ui/media.dart';
import 'package:flutter/material.dart';

class DNForm extends StatelessWidget {
  final bool isTask;
  const DNForm({super.key, required this.isTask});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Info(isTask: isTask),
        if (isTask) const Assign(),
        if (isTask) const Media()
      ],
    );
  }
}

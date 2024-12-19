import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:calendar_flutter/ui/views/task/ui/buttons.dart';
import 'package:calendar_flutter/ui/views/task/ui/content.dart';
import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final routesList = Routes();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => TaskStoreLocal(),
      builder: (context, _) {
        return DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: .7,
          maxChildSize: 1,
          expand: false,
          builder: (context, scrollController) => Container(
            padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
            decoration:
                BoxDecoration(color: Theme.of(context).primaryColorDark),
            child: Stack(
              children: [
                Content(task: widget.task),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Buttons(
                    isDone: widget.task.done,
                    id: widget.task.docId,
                    task: widget.task,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

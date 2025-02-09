import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:calendar_flutter/ui/views/task/ui/buttons.dart';
import 'package:calendar_flutter/ui/views/task/ui/content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  final String id;

  const TaskPage({super.key, required this.id});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskServiceImpl taskService = TaskServiceImpl(firestore);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: taskService.getTask(widget.id),
      builder: (context, snapshot) {
        final TaskModel task = TaskModel.fromJsonWithId(
            snapshot.data?.data(), snapshot.data?.id ?? '');

        if (task.userId.isNotEmpty) {
          return Provider(
            create: (context) => TaskStoreLocal(),
            builder: (context, _) {
              return DraggableScrollableSheet(
                initialChildSize: 1,
                minChildSize: .7,
                maxChildSize: 1,
                expand: false,
                builder: (context, scrollController) => Container(
                  padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                  ),
                  child: Stack(
                    children: [
                      Content(task: task, controller: scrollController),
                      Positioned(
                        bottom: 30,
                        left: 0,
                        right: 0,
                        child: Buttons(
                          isDone: task.done,
                          id: task.docId ?? '',
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

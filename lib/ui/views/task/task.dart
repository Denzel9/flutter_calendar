import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:calendar_flutter/ui/views/task/ui/buttons.dart';
import 'package:calendar_flutter/ui/views/task/ui/content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskPage extends StatefulWidget {
  final String id;
  const TaskPage({super.key, required this.id});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> getTask;

  @override
  void initState() {
    getTask = taskService.getTask(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
        },
        child: Scaffold(
          body: StreamBuilder(
            stream: getTask,
            builder: (context, snapshot) {
              final TaskModel task = TaskModel.fromJsonWithId(
                  snapshot.data?.data(), snapshot.data?.id ?? '');
              if (task.userId.isNotEmpty) {
                return Provider(
                  create: (context) => TaskStoreLocal(),
                  builder: (context, _) => Container(
                    padding:
                        const EdgeInsets.only(top: 60, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    child: Stack(
                      children: [
                        Content(
                          task: task,
                        ),
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
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      );
}

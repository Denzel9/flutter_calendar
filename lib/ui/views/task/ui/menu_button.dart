import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuButton extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String docId;
  final List<Board> boards;
  const MenuButton(
      {super.key,
      required this.docId,
      required this.boards,
      required this.scaffoldKey});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  void checkEmptyBoard(String taskId, List<Board> boards) {
    final emptyBoard = boards.where((el) => el.tasks.contains(taskId)).toList();
    if (emptyBoard.first.tasks.length == 1) {
      boardService.deleteBoard(emptyBoard.first.docId ?? '');
    }
  }

  void showSnackBar() {}

  @override
  Widget build(BuildContext context) {
    final TaskStoreLocal taskStoreLocal = context.watch<TaskStoreLocal>();

    return taskStoreLocal.isDeleting
        ? const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(),
          )
        : PopupMenuButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
              foregroundColor: WidgetStatePropertyAll(Colors.black),
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: () => setState(
                  () => taskStoreLocal.isEdit = !taskStoreLocal.isEdit,
                ),
                child: const DNText(
                  title: 'Edit',
                  color: Colors.black,
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  widget.scaffoldKey.currentState!.setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                          'Are you sure you want to delete the task?'),
                      action: SnackBarAction(
                          textColor: Colors.red,
                          label: 'Delete',
                          onPressed: () {
                            setState(() {
                              taskStoreLocal.isDeleting = true;
                              taskService.deleteTask(widget.docId).then((_) {
                                boardService.deleteTask(
                                    taskStoreLocal.currentBoard, widget.docId);
                              }).then((_) {
                                for (var el in taskStoreLocal.links) {
                                  taskService.deleteAttachments(
                                      widget.docId, el);
                                }
                                checkEmptyBoard(widget.docId, widget.boards);
                              }).then((_) {
                                taskService.isLoading = false;
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              });
                            });
                          }),
                    ));
                  });
                },
                child: const DNText(
                  title: 'Delete',
                  color: Colors.red,
                ),
              ),
            ],
          );
  }
}

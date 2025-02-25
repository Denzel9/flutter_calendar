import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:calendar_flutter/utils/empty_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuButton extends StatefulWidget {
  final String docId;
  final List<Board> boards;
  final bool isOpenedTask;
  final String userId;

  const MenuButton({
    super.key,
    required this.docId,
    required this.boards,
    required this.isOpenedTask,
    required this.userId,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  void checkEmptyBoard(String taskId, List<Board> boards) {
    final Board foundBoard = boards.firstWhere(
      (el) => el.tasks.contains(taskId),
      orElse: () => emptyBoard,
    );

    if (foundBoard.tasks.length == 1) {
      boardService.deleteBoard(foundBoard.docId ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TaskStoreLocal taskStoreLocal = context.watch<TaskStoreLocal>();
    final AppStore store = context.watch<AppStore>();

    return taskStoreLocal.isDeleting
        ? const SizedBox(
            width: 35,
            height: 35,
            child: CircularProgressIndicator(),
          )
        : PopupMenuButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
              foregroundColor: WidgetStatePropertyAll(Colors.black),
            ),
            itemBuilder: (BuildContext context) => [
              if (!widget.isOpenedTask)
                PopupMenuItem(
                  onTap: () => setState(
                    () => taskStoreLocal.isEdit = !taskStoreLocal.isEdit,
                  ),
                  child: const DNText(
                    title: 'Edit',
                    color: Colors.black,
                  ),
                ),
              if (store.user.docId == widget.userId)
                PopupMenuItem(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Are you sure you want to delete the task?'),
                        action: SnackBarAction(
                          textColor: Theme.of(context).colorScheme.error,
                          label: 'Delete',
                          onPressed: () {
                            setState(() {
                              taskStoreLocal.isDeleting = true;
                            });

                            Future.wait([
                              taskService.deleteTask(widget.docId),
                              boardService.deleteTask(
                                  taskStoreLocal.currentBoard, widget.docId),
                            ]);

                            if (taskStoreLocal.links.isNotEmpty) {
                              for (final link in taskStoreLocal.links) {
                                taskService.deleteAttachments(
                                    widget.docId, link);
                              }
                            }

                            checkEmptyBoard(widget.docId, widget.boards);

                            setState(() {
                              Navigator.pop(context);
                              taskService.isLoading = false;
                              taskStoreLocal.isDeleting = false;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: DNText(
                    title: 'Delete',
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
            ],
          );
  }
}

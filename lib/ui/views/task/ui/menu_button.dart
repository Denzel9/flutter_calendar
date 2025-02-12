import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/service/board/board_service_impl.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuButton extends StatefulWidget {
  final String docId;
  final List<Board> boards;
  const MenuButton({super.key, required this.docId, required this.boards});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  final TaskServiceImpl taskService = TaskServiceImpl(firestore);
  final BoardServiceImpl boardService = BoardServiceImpl(firestore);

  void checkEmptyBoard(String taskId, List<Board> boards) {
    final emptyBoard = boards.where((el) => el.tasks.contains(taskId)).toList();
    if (emptyBoard.first.tasks.length == 1) {
      boardService.deleteBoard(emptyBoard.first.docId ?? '');
    }
  }

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
                  setState(() {
                    taskStoreLocal.isDeleting = true;
                    taskService.deleteTask(widget.docId).then((_) {
                      boardService.deleteTask(
                          taskStoreLocal.currentBoard, widget.docId);
                    }).then((_) {
                      for (var el in taskStoreLocal.links) {
                        taskService.deleteAttachments(widget.docId, el);
                      }
                      checkEmptyBoard(widget.docId, widget.boards);
                    }).then((_) {
                      taskService.isLoading = false;
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                  });
                },
                child: const DNText(
                  title: 'Delete',
                  color: Colors.black,
                ),
              ),
            ],
          );
  }
}

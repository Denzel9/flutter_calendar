import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/service/board/board_service_impl.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButton extends StatefulWidget {
  final TabController controller;
  const ActionButton({super.key, required this.controller});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  final TaskServiceImpl taskService = TaskServiceImpl();
  final BoardServiceImpl boardService = BoardServiceImpl();

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final CreateStoreLocal createStoreLocal = context.watch<CreateStoreLocal>();
    return FloatingActionButton(
      clipBehavior: Clip.antiAlias,
      child: Ink(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/pattern.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.amberAccent.shade200,
              BlendMode.multiply,
            ),
          ),
        ),
        child: const Center(
          child: DNText(title: 'Add'),
        ),
      ),
      onPressed: () {
        setState(
          () {
            if (widget.controller.index == 0) {
              taskService.addTask(
                {
                  'author': store.user?.name,
                  'done': false,
                  'board': createStoreLocal.board,
                  'title': createStoreLocal.taskTitle,
                  'description': createStoreLocal.taskDescription,
                  'assign': createStoreLocal.assign,
                  'docId': store.user?.docId,
                  'date': store.selectedDate.toString(),
                  'createdAt': now.toString()
                },
              ).then(
                (taskId) {
                  List<Board> findedBoard = store.boards
                      .where((board) => board.title == createStoreLocal.board)
                      .toList();
                  if (findedBoard.isEmpty) {
                    boardService.addBoard({
                      'author': store.user?.name,
                      'title': createStoreLocal.board,
                      'description': '',
                      'assign': createStoreLocal.assign,
                      'userId': store.user?.docId,
                      'createdAt': now.toString(),
                      'tasks': [taskId]
                    });
                  } else {
                    boardService.addTask(findedBoard.first.docId, taskId);
                  }
                },
              );
            } else {
              () {
                boardService.addBoard(
                  {
                    'author': store.user?.name,
                    'title': createStoreLocal.boardTitle,
                    'description': createStoreLocal.boardDescription,
                    'assign': [],
                    'userId': store.user?.docId,
                    'createdAt': now.toString(),
                    'tasks': []
                  },
                );
              };
            }
            Navigator.pop(context);
            store.selectedDate = now;
          },
        );
      },
    );
  }
}

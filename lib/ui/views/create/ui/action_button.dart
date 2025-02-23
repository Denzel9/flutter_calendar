import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:calendar_flutter/utils/compare_string.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButton extends StatefulWidget {
  final TabController controller;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ActionButton(
      {super.key, required this.controller, required this.scaffoldKey});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  void dispose() {
    if (context.mounted) {
      context.read<AppStore>().selectedDate = now;
    }
    super.dispose();
  }

  void showSnackbar(String title) {
    widget.scaffoldKey.currentState?.setState(() {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(title)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final CreateStoreLocal createStoreLocal = context.watch<CreateStoreLocal>();

    void addTask() {
      if (createStoreLocal.taskTitle.isEmpty) {
        return showSnackbar('Title is required');
      } else {
        setState(() {
          taskService
              .addTask(TaskModel(
            author: store.user.name,
            done: false,
            board: createStoreLocal.board,
            title: createStoreLocal.taskTitle,
            description: createStoreLocal.taskDescription,
            assign: createStoreLocal.assign,
            date: store.selectedDate.toString(),
            createdAt: now.toString(),
            isCollaborated: createStoreLocal.assign.isNotEmpty ? true : false,
            userId: store.user.docId ?? '',
          ).toJson())
              .then(
            (taskId) async {
              List<Board> foundBoard = store.boards
                  .where((board) =>
                      compareString(board.title, createStoreLocal.board))
                  .toList();
              if (foundBoard.isEmpty) {
                boardService.addBoard(
                  Board(
                      author: store.user.name,
                      title: createStoreLocal.board,
                      description: createStoreLocal.taskDescription,
                      userId: store.user.docId ?? '',
                      createdAt: now.toString(),
                      tasks: [taskId]).toJson(),
                );
              } else {
                boardService.addTask(foundBoard.first.docId ?? '', taskId);
              }
              await taskService.addAttachments(createStoreLocal.image, taskId);
            },
          ).then(
            (_) => setState(() {
              Navigator.pop(context);
              taskService.isLoading = false;
            }),
          );
        });
      }
    }

    void addBoard() {
      if (createStoreLocal.boardTitle.isEmpty) {
        return showSnackbar("Title is required");
      } else if (store.boards
          .where((board) =>
              compareString(board.title, createStoreLocal.boardTitle))
          .isNotEmpty) {
        return showSnackbar("The name board already exists");
      }
      setState(() {
        boardService
            .addBoard(
          Board(
              author: store.user.name,
              title: createStoreLocal.boardTitle,
              description: createStoreLocal.taskDescription,
              userId: store.user.docId ?? '',
              createdAt: now.toString(),
              tasks: []).toJson(),
        )
            .then(
          (_) {
            if (context.mounted) {
              setState(() {
                Navigator.pop(context);
              });
            }
          },
        );
      });
    }

    return FloatingActionButton(
      clipBehavior: Clip.antiAlias,
      child: Ink(
        padding:
            taskService.isLoading ? const EdgeInsets.all(10) : EdgeInsets.zero,
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
        child: taskService.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            : const Center(
                child: DNText(title: 'Add'),
              ),
      ),
      onPressed: () {
        if (widget.controller.index == 0) {
          addTask();
        } else {
          addBoard();
        }
      },
    );
  }
}

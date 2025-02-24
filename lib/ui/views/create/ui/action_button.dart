import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:calendar_flutter/utils/compare_string.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/empty_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButton extends StatefulWidget {
  final TabController controller;
  const ActionButton({super.key, required this.controller});

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final CreateStoreLocal createStoreLocal = context.watch<CreateStoreLocal>();

    void addTask() async {
      if (createStoreLocal.taskTitle.isEmpty) {
        return showSnackbar('Title is required');
      } else {
        final taskId = await taskService.addTask(
          TaskModel(
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
          ).toJson(),
        );

        Board? foundBoard = store.boards.firstWhere(
          (board) => compareString(board.title, createStoreLocal.board),
          orElse: () => emptyBoard,
        );

        if (foundBoard.title.isEmpty) {
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
          boardService.addTask(foundBoard.docId ?? '', taskId);
        }

        await taskService.addAttachments(createStoreLocal.image, taskId);

        setState(() {
          Navigator.pop(context);
          taskService.isLoading = false;
          boardService.isLoading = false;
        });
      }
    }

    void addBoard() async {
      if (createStoreLocal.boardTitle.isEmpty) {
        return showSnackbar("Title is required");
      }

      final isNotEqualBoard = store.boards
          .where((board) =>
              compareString(board.title, createStoreLocal.boardTitle))
          .isNotEmpty;

      if (isNotEqualBoard) {
        return showSnackbar("The name board already exists");
      }

      await boardService.addBoard(
        Board(
            author: store.user.name,
            title: createStoreLocal.boardTitle,
            description: createStoreLocal.boardDescription,
            userId: store.user.docId ?? '',
            createdAt: now.toString(),
            tasks: []).toJson(),
      );

      setState(() {
        boardService.isLoading = false;
        Navigator.pop(context);
      });
    }

    bool isLoading = taskService.isLoading || boardService.isLoading;

    return FloatingActionButton(
      clipBehavior: Clip.antiAlias,
      child: Ink(
        padding: isLoading ? const EdgeInsets.all(10) : EdgeInsets.zero,
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
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(),
              )
            : const Center(
                child: DNText(title: 'Add'),
              ),
      ),
      onPressed: () => setState(
        () {
          widget.controller.index == 0 ? addTask() : addBoard();
        },
      ),
    );
  }
}

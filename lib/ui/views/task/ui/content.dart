import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/service/board/board_service_impl.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

enum SampleItem { delete, edit }

class Content extends StatefulWidget {
  final Task task;
  const Content({super.key, required this.task});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final editController = TextEditingController();
  final TaskServiceImpl taskService = TaskServiceImpl();
  final BoardServiceImpl boardService = BoardServiceImpl();

  void checkEmptyBoard(String taskId, List<Board> boards) {
    final emptyBoard = boards.where((el) => el.tasks.contains(taskId)).toList();
    if (emptyBoard.first.tasks.length == 1) {
      boardService.deleteBoard(emptyBoard.first.docId);
    }
  }

  @override
  void didChangeDependencies() {
    List<Board> boards = context.watch<AppStore>().boards;
    setState(() {
      context.watch<TaskStoreLocal>().currentBoard =
          boards.where((el) => el.title == widget.task.board).first.docId;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TaskStoreLocal taskStoreLocal = context.watch<TaskStoreLocal>();
    final AppStore store = context.watch<AppStore>();
    return SingleChildScrollView(
      child: Observer(
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DNIconButton(
                      icon: const Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.amberAccent,
                      onClick: () => Navigator.pop(context)),
                  PopupMenuButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.amberAccent),
                        foregroundColor: WidgetStatePropertyAll(Colors.black)),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<SampleItem>>[
                      PopupMenuItem<SampleItem>(
                        value: SampleItem.edit,
                        onTap: () => setState(
                          () => taskStoreLocal.isEdit = !taskStoreLocal.isEdit,
                        ),
                        child: const DNText(
                          title: 'Edit',
                          color: Colors.black,
                        ),
                      ),
                      PopupMenuItem<SampleItem>(
                        value: SampleItem.delete,
                        onTap: () {
                          setState(() {
                            taskService.deleteTask(widget.task.docId).then((_) {
                              boardService.deleteTask(
                                  taskStoreLocal.currentBoard,
                                  widget.task.docId);
                            }).then((_) => checkEmptyBoard(
                                widget.task.docId, store.boards));
                          });
                          Navigator.pop(context);
                        },
                        child: const DNText(
                          title: 'Delete',
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                margin: const EdgeInsets.only(top: 20, bottom: 50),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.amberAccent),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  widget.task.board,
                  style: const TextStyle(color: Colors.amberAccent),
                ),
              ),
              DNEditableField(
                title: widget.task.title,
                isEdit: taskStoreLocal.isEdit,
                editField: 'title',
                controller: editController,
                taskId: widget.task.docId,
                maxFontSize: 40,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DNText(
                      title: 'Time',
                      opacity: .5,
                    ),
                    DNText(
                      title: 'Assignee',
                      opacity: .5,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DNText(
                            title: getFormatTime(widget.task.date),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                      subtitle: DNText(
                        title: getFormatDate(widget.task.date),
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (widget.task.assign.isNotEmpty)
                    SizedBox(
                      width: 250,
                      height: 40,
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children:
                            List.generate(widget.task.assign.length, (index) {
                          return Positioned(
                            right: index * 25,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                widget.task.assign[index]
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase(),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  if (widget.task.assign.isEmpty)
                    DNButton(
                      title: 'Add',
                      isPrimary: false,
                      onClick: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const SizedBox(
                              width: double.infinity,
                              height: 300,
                            );
                          },
                        );
                      },
                    )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const DNText(
                title: 'Description',
                opacity: .5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: DNEditableField(
                  title: widget.task.description,
                  isEdit: taskStoreLocal.isEdit,
                  editField: 'description',
                  controller: editController,
                  taskId: widget.task.docId,
                ),
              ),
              const DNText(
                title: 'Created',
                opacity: .5,
              ),
              if (widget.task.author.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DNText(
                    title: widget.task.createdAt.isNotEmpty
                        ? '${getFormatDate(widget.task.createdAt)}, by ${widget.task.author}'
                        : widget.task.author,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

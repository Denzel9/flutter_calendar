import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/service/board/board_service_impl.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/store/task.dart';
import 'package:calendar_flutter/ui/views/task/ui/assign.dart';
import 'package:calendar_flutter/ui/views/task/ui/attachments.dart';
import 'package:calendar_flutter/ui/views/task/ui/board_button.dart';
import 'package:calendar_flutter/ui/views/task/ui/menu_button.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/parse_link_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Content extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final TaskModel task;
  const Content({
    super.key,
    required this.task,
    required this.scaffoldKey,
  });

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final editController = TextEditingController();
  final TaskServiceImpl taskService = TaskServiceImpl(firestore);
  final UserServiceImpl userService = UserServiceImpl(firestore);
  final BoardServiceImpl boardService = BoardServiceImpl(firestore);

  @override
  void didChangeDependencies() async {
    final List<Board> boards = context.watch<AppStore>().boards;
    final TaskStoreLocal taskStoreLocal = context.watch<TaskStoreLocal>();

    setState(() {
      context.watch<TaskStoreLocal>().currentBoard =
          boards.where((el) => el.title == widget.task.board).first.docId ?? '';

      taskService.getAttachments(widget.task.docId ?? '').then((value) {
        setState(() {
          taskStoreLocal.links = value
              .map(
                  (el) => parseLinkImage(el.split('%2F').last.split('.').first))
              .toList();
        });
      });
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

    return Observer(
      builder: (_) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DNIconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ),
                  onClick: () {
                    widget.scaffoldKey.currentState!.setState(() {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    });
                    Navigator.pop(context);
                  },
                ),
                MenuButton(
                  docId: widget.task.docId ?? '',
                  boards: store.boards,
                  scaffoldKey: widget.scaffoldKey,
                )
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 30),
                children: [
                  BoardButton(
                    board: widget.task.board,
                    boards: store.boards,
                  ),
                  DNEditableField(
                    title: widget.task.title,
                    isEdit: taskStoreLocal.isEdit,
                    editField: 'title',
                    docId: widget.task.docId ?? '',
                    maxFontSize: 40,
                    minFontSize: 20,
                    updateField: taskService.updateField,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const DNText(
                          title: 'Time',
                          opacity: .5,
                          fontWeight: FontWeight.bold,
                        ),
                        if (!widget.task.done)
                          const DNText(
                            title: 'Assignee',
                            opacity: .5,
                            fontWeight: FontWeight.bold,
                          ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (!widget.task.done)
                        Assign(
                          docId: widget.task.docId ?? '',
                          assignList: widget.task.assign,
                        )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: DNEditableField(
                      title: widget.task.description,
                      isEdit: taskStoreLocal.isEdit,
                      editField: 'description',
                      docId: widget.task.docId ?? '',
                      updateField: taskService.updateField,
                    ),
                  ),
                  const DNText(
                    title: 'Created',
                    opacity: .5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: DNText(
                      title:
                          '${getFormatDate(widget.task.createdAt)}, by ${widget.task.author}',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Attachments(
                    docId: widget.task.docId ?? '',
                    isDone: widget.task.done,
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

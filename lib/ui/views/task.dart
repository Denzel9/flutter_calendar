import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/service/board/board_service_impl.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/store/board/board.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SampleItem { delete, edit }

class TaskPage extends StatefulWidget {
  final Task task;

  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late BoardStore _boardStore;
  late BoardServiceImpl _boardService;
  late TaskServiceImpl _taskService;

  @override
  void didChangeDependencies() {
    _boardStore = Provider.of<BoardStore>(context);
    _boardService = Provider.of<BoardServiceImpl>(context);
    _taskService = Provider.of<TaskServiceImpl>(context);
    super.didChangeDependencies();
  }

  void checkEmptyBoard(String taskId) {
    final emptyBoard =
        _boardStore.board.where((el) => el.tasks.contains(taskId)).toList();
    if (emptyBoard.first.tasks.length == 1) {
      _boardService.deleteBoard(emptyBoard.first.docId);
    }
  }

  final editController = TextEditingController();
  final routesList = Routes();
  late String currentBoard;
  bool isEdit = false;

  @override
  void initState() {
    currentBoard = _boardStore.board
        .where((el) => el.title == widget.task.board)
        .first
        .docId;
    super.initState();
  }

  @override
  void dispose() {
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: .7,
      maxChildSize: 1,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
        decoration: const BoxDecoration(color: Color.fromARGB(255, 58, 58, 58)),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
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
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.black)),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<SampleItem>>[
                          PopupMenuItem<SampleItem>(
                            value: SampleItem.edit,
                            onTap: () => setState(() => isEdit = !isEdit),
                            child: const DNText(
                              title: 'Edit',
                              color: Colors.black,
                            ),
                          ),
                          PopupMenuItem<SampleItem>(
                            value: SampleItem.delete,
                            onTap: () {
                              _taskService.deleteTask(widget.task.docId).then(
                                  (_) {
                                _boardService.deleteTask(
                                    currentBoard, widget.task.docId);
                              }).then(
                                  (_) => checkEmptyBoard(widget.task.docId));
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
                  // MAKE IS CLECKABLE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
                  //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                  DNEditableField(
                    title: widget.task.title,
                    isEdit: isEdit,
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
                          title: DNText(
                              title: getFormatTime(widget.task.date),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
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
                            children: List.generate(widget.task.assign.length,
                                (index) {
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
                      isEdit: isEdit,
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
              ),
            ),
            if (!widget.task.done && !isEdit)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: AnimatedToggleSwitch<bool>.rolling(
                  current: widget.task.done,
                  spacing: double.infinity,
                  height: 70,
                  indicatorSize: const Size.fromWidth(70),
                  values: const [false, true],
                  style: const ToggleStyle(
                      backgroundColor: Colors.black,
                      indicatorColor: Colors.white),
                  iconBuilder: (value, index) => widget.task.done == value
                      ? const Icon(Icons.done, color: Colors.black, size: 40)
                      : const DNText(title: 'Done', color: Colors.white),
                  iconsTappable: false,
                  onChanged: (i) {
                    _taskService.changeDone(
                        widget.task.docId, !widget.task.done);
                    Navigator.pop(context);
                  },
                ),
              ),
            if (isEdit)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: () => setState(() => isEdit = false),
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.green),
                    fixedSize: WidgetStatePropertyAll(Size(50, 70)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DNText(
                        title: 'Save',
                      ),
                      Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.task.done)
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: DNButton(
                  title: 'Cancel Is Done',
                  onClick: () {
                    _taskService.changeDone(
                        widget.task.docId, !widget.task.done);
                    Navigator.pop(context);
                  },
                  isPrimary: true,
                  backgroundColor: Colors.red,
                  color: Colors.white,
                ),
              )
          ],
        ),
      ),
    );
  }
}

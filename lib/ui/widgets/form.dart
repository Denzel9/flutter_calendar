import 'dart:io';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/board/board.dart';
import 'package:calendar_flutter/store/task/task.dart';
import 'package:calendar_flutter/store/user/user.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/widgets/date_picker.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

class DNForm extends StatefulWidget {
  final bool isTask;

  const DNForm({
    super.key,
    required this.isTask,
  });

  @override
  State<DNForm> createState() => _FormState();
}

class _FormState extends State<DNForm> {
  List<String> listBoards = ['Myself', "Work", 'Learning', "Default"];
  late TaskStore _taskStore;
  late BoardStore _boardStore;
  late UserStore _userStore;
  late UserServiceImpl _userService;
  final ImagePicker imagePicker = ImagePicker();
  List<String> assignList = [];
  List<String> boards = [];
  String assignHint = '';
  bool isEdit = false;
  File? image;

  @override
  void initState() {
    assignList = [..._userStore.user.followers, 'add'];
    boards = _taskStore.tasks.map((el) => el.board).toList();
    listBoards = <String>{...listBoards, ...boards}.toList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _taskStore = Provider.of<TaskStore>(context);
    _boardStore = Provider.of<BoardStore>(context);
    _userStore = Provider.of<UserStore>(context);
    _userService = Provider.of<UserServiceImpl>(context);

    assignHint = _taskStore.assign.isNotEmpty
        ? _taskStore.assign.length > 1
            ? "${_taskStore.assign.first} and ${_taskStore.assign.length - 1} people"
            : _taskStore.assign.first
        : 'Assign';
  }

  // @override
  // void didChangeDependencies() {
  //
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    selectedDate = DateTime.now();
    boards = [];
    _taskStore.clearBoard();
    assignHint = '';
    _taskStore.clearAssign();
    _taskStore.title = '';
    _boardStore.title = '';
    _taskStore.description = '';
    _boardStore.description = '';
    super.dispose();
  }

  Future<void> pickImage() async {
    XFile? xFileImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFileImage != null) {
      setState(() {
        image = File(xFileImage.path);
      });
    }
  }

  handleAddAssign(String id) {
    setState(
      () {
        if (_taskStore.assign.where((el) => el == id).isEmpty) {
          _taskStore.setAssign(id);
        }
        Navigator.pop(context);
      },
    );
  }

  void showAssign() {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 35, 35, 35),
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(top: 20),
          child: FutureBuilder(
            future: _userService.getFollowers(_userStore.user.docId),
            builder: (context, snap) {
              return ListView.builder(
                itemCount: snap.data?.length,
                itemBuilder: (context, index) {
                  final user = snap.data?[index];
                  return ListTile(
                    title: DNText(
                      title: user?.name ?? '',
                    ),
                    subtitle: DNText(
                      title: user?.lastName ?? '',
                    ),
                    leading: ClipOval(
                      child: FutureBuilder(
                        future: _userService.getAvatar(user?.docId),
                        builder: (context, snap) {
                          return ClipOval(
                            child: Image.network(
                              snap.data!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    trailing: DNIconButton(
                      onClick: () => handleAddAssign(user?.docId ?? ''),
                      icon: const Icon(Icons.add),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DNInput(
            title: 'Title',
            fontWeight: FontWeight.bold,
            fontSize: 25,
            opacity: .5,
            borderColor: Colors.white12,
            // onClick: (value) => widget.isTask
            //     ? taskStore.title = value
            //     : boardStore.title = value,
          ),
          const SizedBox(
            height: 10,
          ),
          DNInput(
            title: 'Description',
            fontWeight: FontWeight.bold,
            fontSize: 25,
            opacity: .5,
            countLines: 3,
            borderColor: Colors.white12,
            // onClick: (value) => widget.isTask
            //     ? taskStore.description = value
            //     : boardStore.description = value,
          ),
          const SizedBox(
            height: 30,
          ),
          DatePicker(
            title:
                '${weekDaysSlice[selectedDate.weekday - 1]} ${formatDatePadLeft(selectedDate.day)}, ${selectedDate.year} ${formatDatePadLeft(selectedDate.hour)}:${formatDatePadLeft(selectedDate.minute)}',
            onChanged: (DateTime newDate) =>
                setState(() => selectedDate = newDate),
          ),
          const SizedBox(
            height: 30,
          ),
          if (widget.isTask)
            // DNSelect(
            //   boards: listBoards,
            //   value: taskStore.board,
            //   onClick: (value) {
            //     setState(() {
            //       taskStore.setBoard(value!);
            //     });
            //   },
            // ),
            if (widget.isTask)
              const SizedBox(
                height: 30,
              ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const DNText(
                title: 'Assign',
                opacity: .5,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              // if (taskStore.assign.isNotEmpty)
              //   GestureDetector(
              //     child: const DNText(
              //       title: 'Edit',
              //       opacity: .5,
              //       fontWeight: FontWeight.bold,
              //     ),
              //     onTap: () {},
              //   )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: AlignmentDirectional.center,
                      children: [
                        for (var i = 0; i < _taskStore.assign.length; i++)
                          Positioned(
                            left: i * 30,
                            child: FutureBuilder(
                              future:
                                  _userService.getAvatar(_taskStore.assign[i]),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  return ClipOval(
                                    child: Image.network(
                                      snap.data.toString(),
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                    ),
                                  );
                                }
                                return const ClipOval(
                                  child: ColoredBox(color: Colors.red),
                                );
                              },
                            ),
                          ),
                        Positioned(
                          left: _taskStore.assign.length * 30,
                          child: DNIconButton(
                            onClick: showAssign,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DNText(
            title: 'Media',
            opacity: .5,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          if (image?.path.isEmpty ?? false)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: DNIconButton(
                onClick: pickImage,
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
          // add component AttachmentImage
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                if (image?.path.isNotEmpty ?? false)
                  Image.file(
                    image as File,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                if (image?.path.isNotEmpty ?? false)
                  const SizedBox(
                    width: 10,
                  ),
                DNIconButton(icon: const Icon(Icons.add), onClick: () {})
              ],
            ),
          )
        ],
      ),
    );
  }
}

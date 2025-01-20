import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:calendar_flutter/ui/widgets/date_picker.dart';
import 'package:calendar_flutter/ui/widgets/select.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

List<String> listBoards = ['Myself', "Work", 'Learning', "Default"];

class Main extends StatefulWidget {
  final bool isTask;
  const Main({super.key, required this.isTask});

  @override
  State<Main> createState() => _InfoState();
}

class _InfoState extends State<Main> {
  @override
  void didChangeDependencies() {
    final List<Board> boards = context.read<AppStore>().boards as List<Board>;
    final boardsTitles = boards.map((el) => el.title).toList();
    listBoards = <String>{...listBoards, ...boardsTitles}.toList();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final CreateStoreLocal createStore = context.watch<CreateStoreLocal>();
    final AppStore store = context.watch<AppStore>();
    final datePickerTitle =
        '${weekDaysSlice[store.selectedDate.weekday - 1]} ${formatDatePadLeft(store.selectedDate.day)}, ${store.selectedDate.year} ${formatDatePadLeft(store.selectedDate.hour)}:${formatDatePadLeft(store.selectedDate.minute)}';

    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DNInput(
              title: 'Title',
              fontWeight: FontWeight.bold,
              fontSize: 25,
              opacity: .5,
              borderColor: Colors.white12,
              onClick: (value) => setState(() {
                widget.isTask
                    ? createStore.taskTitle = value
                    : createStore.boardTitle = value;
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: DNInput(
                title: 'Description',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                opacity: .5,
                countLines: 3,
                borderColor: Colors.white12,
                onClick: (value) => setState(() {
                  widget.isTask
                      ? createStore.taskDescription = value
                      : createStore.boardDescription = value;
                }),
              ),
            ),
            DatePicker(
              title: datePickerTitle,
              onChanged: (DateTime newDate) =>
                  setState(() => store.selectedDate = newDate),
            ),
            const SizedBox(
              height: 30,
            ),
            if (widget.isTask)
              DNSelect(
                boards: listBoards,
                value: createStore.board,
                onClick: (int index) {
                  setState(() {
                    createStore.board = listBoards[index];
                  });
                },
              ),
            if (widget.isTask)
              const SizedBox(
                height: 30,
              ),
          ],
        );
      },
    );
  }
}

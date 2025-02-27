import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/viewing/store/viewing.dart';
import 'package:calendar_flutter/ui/views/viewing/ui/calendar.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class HeaderCalendar extends StatefulWidget {
  final List<TaskModel> tasks;
  final TabController controller;
  const HeaderCalendar({
    super.key,
    required this.tasks,
    required this.controller,
  });

  @override
  State<HeaderCalendar> createState() => _HeaderCalendarState();
}

class _HeaderCalendarState extends State<HeaderCalendar> {
  @override
  Widget build(BuildContext context) {
    final ViewingStoreLocal viewingStoreLocal =
        context.watch<ViewingStoreLocal>();
    final AppStore store = context.watch<AppStore>();

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: viewingStoreLocal.isOpenCalendar ? 330 : 0,
          width: double.infinity,
          color: Colors.amberAccent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Calendar(
              onClick: (DateTime day) => setState(
                () {
                  store.selectedDate = day;
                  viewingStoreLocal.selectedDate = day;
                  viewingStoreLocal.isOpenCalendar =
                      !viewingStoreLocal.isOpenCalendar;
                  widget.controller.index = 0;
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(
                color: Colors.amberAccent,
                onPressed: () {
                  Navigator.pop(context);
                  store.selectedDate = now;
                },
              ),
              Observer(
                builder: (_) => DNText(
                  title:
                      '${viewingStoreLocal.selectedDate.day} ${monthsFullNames[store.selectedDate.month - 1]}, ${viewingStoreLocal.selectedDate.year}',
                ),
              ),
              DNIconButton(
                icon: const Icon(Icons.calendar_month),
                onClick: () => setState(() {
                  viewingStoreLocal.isOpenCalendar =
                      !viewingStoreLocal.isOpenCalendar;
                  widget.controller.index = 0;
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

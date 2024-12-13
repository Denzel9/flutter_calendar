import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  final void Function(DateTime day) onClick;
  final ScrollController controller;
  final DateTime selectedDate;
  const Calendar(
      {super.key,
      required this.onClick,
      required this.selectedDate,
      required this.controller});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final dates = {};
  // final tasks = Controller.taskStore.tasks;
  final String currentDate = now.toString().split(' ')[0];

  List<DateTime> generateCalendar(int month) {
    DateTimeRange dateTimeRange = DateTimeRange(
        start: DateTime(now.year, month + 1),
        end: DateTime(now.year, month + 2));

    final daysToGenerate =
        dateTimeRange.end.difference(dateTimeRange.start).inDays;

    final days = List.generate(
      daysToGenerate,
      (i) => DateTime(
        dateTimeRange.start.year,
        dateTimeRange.start.month,
        dateTimeRange.start.day + (i),
      ),
    );

    return days;
  }

  @override
  void initState() {
    for (var i = 0; i < 12; i++) {
      dates[monthsFullNames[i]] = generateCalendar(i);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: widget.controller,
        padding: const EdgeInsets.only(top: 0),
        itemCount: 12,
        itemBuilder: (context, month) {
          return SizedBox(
            height: 250,
            child: Column(
              children: [
                DNText(
                  title: monthsFullNames[month],
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                Expanded(
                    child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisExtent: 40,
                  ),
                  padding: const EdgeInsets.only(top: 0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dates.length,
                  itemBuilder: (context, day) {
                    final dayDate = dates[day].toString().split(' ')[0];
                    final String selectDate =
                        widget.selectedDate.toString().split(' ')[0];
                    // final todayTasks = tasks
                    //     .where(
                    //         (element) => element.date.split(' ')[0] == dayDate)
                    //     .toList();
                    return GestureDetector(
                      onTap: () => widget.onClick(dates[day]),
                      child: ColoredBox(
                        color: currentDate == dayDate
                            ? Colors.black.withOpacity(.5)
                            : selectDate == dayDate
                                ? Colors.black.withOpacity(.1)
                                : Colors.transparent,
                        child: Stack(children: [
                          Positioned(
                            child: DNText(
                              title: (day + 1).toString(),
                              fontWeight: FontWeight.normal,
                              color: currentDate == dayDate
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          // for (final _ in todayTasks)
                          //   const Positioned(
                          //       left: 2,
                          //       top: 2,
                          //       child: ClipOval(
                          //         child: ColoredBox(
                          //           color: Colors.white,
                          //           child: SizedBox(
                          //             width: 6,
                          //             height: 6,
                          //           ),
                          //         ),
                          //       )),
                        ]),
                      ),
                    );
                  },
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}

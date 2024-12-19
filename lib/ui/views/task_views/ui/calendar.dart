import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  final void Function(DateTime day) onClick;
  final int selectedMonth;
  final List<Task> tasks;

  const Calendar({
    super.key,
    required this.onClick,
    required this.tasks,
    required this.selectedMonth,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final dates = {};
  final String currentDate = now.toString().split(' ')[0];
  double? currentOffset;

  late final ScrollController scrollController;

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
    scrollController = ScrollController(
        initialScrollOffset: currentOffset ?? (widget.selectedMonth - 1) * 250);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DNText(
              title: currenYear.toString(),
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            GestureDetector(
              onTap: () => setState(
                () {
                  store.selectedDate = now;
                  scrollController.animateTo(
                    (now.month - 1) * 250,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.bounceIn,
                  );
                },
              ),
              child: const DNText(
                title: 'Reset',
                color: Colors.black,
                fontSize: 20,
                opacity: .5,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
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
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisExtent: 40,
                        ),
                        padding: const EdgeInsets.only(top: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dates[monthsFullNames[month]].length,
                        itemBuilder: (context, day) {
                          final dayDate = dates[monthsFullNames[month]][day]
                              .toString()
                              .split(' ')[0];
                          final String selectDate =
                              store.selectedDate.toString().split(' ')[0];
                          final todayTasks = widget.tasks
                              .where((element) =>
                                  element.date.split(' ')[0] == dayDate)
                              .toList();
                          return GestureDetector(
                            onTap: () {
                              widget
                                  .onClick(dates[monthsFullNames[month]][day]);
                              currentOffset = scrollController.offset;
                            },
                            child: ColoredBox(
                              color: currentDate == dayDate
                                  ? Colors.black.withOpacity(.5)
                                  : selectDate == dayDate
                                      ? Colors.black.withOpacity(.1)
                                      : Colors.transparent,
                              child: Stack(
                                children: [
                                  Positioned(
                                    child: Center(
                                      child: DNText(
                                        title: (day + 1).toString(),
                                        fontWeight: FontWeight.normal,
                                        color: currentDate == dayDate
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  for (final _ in todayTasks)
                                    const Positioned(
                                      left: 2,
                                      top: 2,
                                      child: ClipOval(
                                        child: ColoredBox(
                                          color: Colors.white,
                                          child: SizedBox(
                                            width: 6,
                                            height: 6,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

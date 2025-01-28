import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  final void Function(DateTime day) onClick;

  const Calendar({
    super.key,
    required this.onClick,
  });

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late final ScrollController scrollController;
  final String currentDate = getFormatDate(now.toString());

  final dates = {};
  double? currentOffset;

  @override
  void initState() {
    for (var i = 0; i < 12; i++) {
      dates[monthsFullNames[i]] = generateCalendar(i);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final int month = context.watch<AppStore>().selectedDate.month;
    scrollController = ScrollController(
        initialScrollOffset: currentOffset ?? (month - 1) * 270);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final String selectDate = getSliceDate(store.selectedDate.toString());

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            child: Row(
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
                      scrollController.animateTo(
                        (now.month - 1) * 270,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      widget.onClick(dates[monthsFullNames[currentMonth - 1]]
                          [currenDay + 1]);
                      currentOffset = scrollController.offset;
                    },
                  ),
                  child: const DNText(
                    title: 'Reset',
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: ListView.builder(
            controller: scrollController,
            itemCount: dates.length,
            itemBuilder: (context, month) {
              final weekday = getWeekday(month);
              return SizedBox(
                height: 270,
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
                          final dayDate = getSliceDate(
                              dates[monthsFullNames[month]][day].toString());
                          final todayTasks = store.tasks
                              .where((element) =>
                                  element.date.split(' ')[0] == dayDate)
                              .toList();
                          return getSliceYear(dayDate) == 1000
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    widget.onClick(
                                        dates[monthsFullNames[month]][day]);
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
                                              title: (day - weekday + 1)
                                                  .toString(),
                                              color: currentDate == dayDate
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        for (final _ in todayTasks)
                                          const Positioned(
                                            right: 2,
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

import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ContentSliver extends StatefulWidget {
  final TabController controller;
  const ContentSliver({
    super.key,
    required this.controller,
  });

  @override
  State<ContentSliver> createState() => _ContentSliverState();
}

class _ContentSliverState extends State<ContentSliver> {
  final routesList = Routes();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColorDark,
      surfaceTintColor: Colors.white,
      elevation: 0,
      pinned: true,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: SizedBox(),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            Observer(
              builder: (_) {
                return TabBar(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  onTap: (value) => setState(() {}),
                  controller: widget.controller,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.amberAccent,
                  unselectedLabelColor: Colors.white54,
                  labelColor: Colors.amberAccent,
                  overlayColor: WidgetStateProperty.all(
                      Colors.amberAccent.withOpacity(0.1)),
                  tabs: [
                    Tab(
                      height: 60,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: DNText(
                          title: '${store.tasks.length} Tasks',
                          fontSize: 25,
                          color: widget.controller.index == 0
                              ? Colors.amberAccent
                              : Colors.white,
                        ),
                      ),
                    ),
                    Tab(
                      height: 60,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: DNText(
                          title: '${store.boards.length} Boards',
                          fontSize: 25,
                          color: widget.controller.index == 1
                              ? Colors.amberAccent
                              : Colors.white,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(top: 20),
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Row(
                  children: [
                    DNButton(
                      title: 'Active',
                      onClick: () => setState(() => store.isActiveTask = true),
                      isPrimary: store.isActiveTask,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DNButton(
                      title: 'Done',
                      onClick: () => setState(() => store.isActiveTask = false),
                      isPrimary: !store.isActiveTask,
                    ),
                    const Expanded(child: SizedBox()),
                    DNIconButton(
                      icon: const Icon(Icons.north_east, color: Colors.black),
                      onClick: () =>
                          Navigator.pushNamed(context, routesList.tasks),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  weekDaysSlice.length,
                  (index) {
                    final isToday = weekDaysSlice[currenWeekDayIndex - 1] ==
                        weekDaysSlice[index];
                    final computedDate = now
                        .add(Duration(days: index - (currenWeekDayIndex - 1)));
                    return GestureDetector(
                      onTap: () => setState(
                        () {
                          if (currenWeekDayIndex - 1 == index) {
                            store.selectedDate = DateTime.now();
                          } else {
                            store.selectedDate = computedDate;
                          }
                        },
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Observer(
                            builder: (_) => Row(
                              children: [
                                for (int i = 0;
                                    i <
                                            filteredTask(
                                              date: computedDate,
                                              store: store,
                                            ).length &&
                                        i <= 3;
                                    i++)
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          DNText(
                            title: isToday ? 'Today' : weekDaysSlice[index],
                            fontSize: 18,
                            opacity: isToday ? 1 : .5,
                            color: isToday ||
                                    weekDaysSlice[
                                            store.selectedDate.weekday - 1] ==
                                        weekDaysSlice[index]
                                ? Colors.amberAccent
                                : Colors.white,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

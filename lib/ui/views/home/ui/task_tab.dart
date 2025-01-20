import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/home/store/home.dart';
import 'package:calendar_flutter/ui/views/task_views/task_view_page.dart';
import 'package:calendar_flutter/ui/widgets/info_card.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final HomeStoreLocal homeStoreLocal = context.watch<HomeStoreLocal>();

    return Observer(
      builder: (_) {
        final tasks = filteredTask(
          store: store,
          isActiveTask: homeStoreLocal.isActiveTask,
          isArchive: !homeStoreLocal.isActiveTask,
          isCollaborationTasks: homeStoreLocal.isCollaborationTasks,
        );

        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      DNButton(
                        title: 'Active',
                        onClick: () => setState(() {
                          homeStoreLocal.isActiveTask = true;
                        }),
                        isPrimary: homeStoreLocal.isActiveTask,
                      ),
                      Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Center(
                              child: DNText(
                                title: store.listActiveTask.length.toString(),
                                fontSize: 14,
                              ),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(width: 10),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      DNButton(
                        title: 'Archive',
                        onClick: () =>
                            setState(() => homeStoreLocal.isActiveTask = false),
                        isPrimary: !homeStoreLocal.isActiveTask,
                      ),
                      Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              border: Border.all(color: Colors.white),
                            ),
                            child: Center(
                              child: DNText(
                                title: store.listArchiveTasks.length.toString(),
                                fontSize: 14,
                              ),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DNIconButton(
                    icon: Icon(Icons.people,
                        color: homeStoreLocal.isCollaborationTasks
                            ? Colors.black
                            : Colors.white),
                    onClick: () => setState(() {
                      homeStoreLocal.isCollaborationTasks =
                          !homeStoreLocal.isCollaborationTasks;
                    }),
                    backgroundColor: homeStoreLocal.isCollaborationTasks
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  ),
                  const Expanded(child: SizedBox()),
                  DNIconButton(
                    icon: const Icon(Icons.north_east, color: Colors.black),
                    onClick: () =>
                        Navigator.pushNamed(context, routesList.tasks),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  weekDaysSlice.length,
                  (index) {
                    final isToday = weekDaysSlice[currenWeekDayIndex - 1] ==
                        weekDaysSlice[index];
                    final computedDate = now
                        .add(Duration(days: index - (currenWeekDayIndex - 1)));
                    final tasksCount = filteredTask(
                      date: computedDate,
                      store: store,
                    ).length;
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (currenWeekDayIndex - 1 == index) {
                          store.selectedDate = DateTime.now();
                        } else {
                          store.selectedDate = computedDate;
                        }
                      }),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Row(
                              children: List.generate(
                                tasksCount,
                                (index) {
                                  return Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          DNText(
                            title: isToday ? 'Today' : weekDaysSlice[index],
                            fontSize: 18,
                            height: 1.5,
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
              if (tasks.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return InfoCard(data: task);
                    },
                  ),
                ),
              if (tasks.isEmpty)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const DNText(
                        title: 'Empty',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        opacity: .5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      if (store.todayTasks.isEmpty &&
                          store.nextTasks.isNotEmpty)
                        GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DNText(
                                title:
                                    'Next ${getFormatDate(store.nextTasks.first.date)}',
                                opacity: .5,
                              ),
                              const Icon(
                                Icons.north_east,
                                color: Colors.white38,
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskViewPage(
                                  date: DateTime.parse(
                                    getSliceDate(store.nextTasks.first.date)
                                        .split('.')
                                        .reversed
                                        .join(),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

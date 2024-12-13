import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user.dart';
import 'package:calendar_flutter/ui/widgets/tab_bar.dart';
import 'package:calendar_flutter/ui/widgets/info_card.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // DateTime selectedDate = Controller.selectedDate;
  final routesList = Routes();
  late final _tabController =
      TabController(length: 2, vsync: this, initialIndex: 0);

  @override
  void dispose() {
    selectedDate = now;
    _tabController.dispose();
    super.dispose();
  }

  int getPercent(List<Task> tasks) {
    if (tasks.isNotEmpty) {
      final completedTask = tasks.where((task) => task.done).length;
      return (completedTask * 100 / tasks.length).ceil();
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    print(store);
    return Scaffold(
      body: NestedScrollView(
        scrollBehavior: _tabController.index == 0 &&
                filteredTask(
                  date: DateTime.now(),
                  store: store,
                ).isEmpty
            ? const MaterialScrollBehavior().copyWith(
                physics: const NeverScrollableScrollPhysics(), dragDevices: {})
            : null,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            toolbarHeight: 0,
            expandedHeight: 330,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 60.0,
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const UserPage();
                                    },
                                  ),
                                ),
                            child: Observer(
                              builder: (_) => Text(
                                store.user?.docId ?? '',
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                            // FutureBuilder(
                            //   future: userService.getAvatar(),
                            //   builder: (context, snap) {
                            //     return SizedBox(
                            //       width: 40,
                            //       height: 40,
                            //       child: ClipOval(
                            //         child: Image.network(
                            //           snap.data ?? '',
                            //           fit: BoxFit.cover,
                            //           width: 40,
                            //           height: 40,
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // ),
                            ),
                        DNIconButton(
                          icon: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          onClick: () =>
                              Navigator.pushNamed(context, routesList.search),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DNText(
                          title: 'Good',
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                        DNText(
                          title: getDayTitle(),
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: DNText(title: "Today's $weekDayName"),
                          subtitle: DNText(
                            title: "$monthSlice $currenDay, $currenYear",
                            fontSize: 15,
                            opacity: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: ListTile(
                          title: Align(
                            alignment: Alignment.centerRight,
                            child: Observer(builder: (_) {
                              return DNText(
                                title: "${getPercent(store.tasks)}% done",
                              );
                            }),
                          ),
                          subtitle: const Align(
                            alignment: Alignment.centerRight,
                            child: DNText(
                              title: "Completed Task",
                              fontSize: 15,
                              opacity: .5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            pinned: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(65),
              child: SizedBox(),
            ),
            flexibleSpace: Column(
              children: [
                Observer(builder: (_) {
                  return TabBar(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    onTap: (value) => setState(() {}),
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Colors.amberAccent,
                    unselectedLabelColor: Colors.white54,
                    labelColor: Colors.amberAccent,
                    overlayColor: WidgetStateProperty.all(
                        Colors.amberAccent.withOpacity(0.1)),
                    tabs: [
                      Tab(
                        height: 50,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DNText(
                            title: '${store.tasks.length} Tasks',
                            fontSize: 25,
                            color: _tabController.index == 0
                                ? Colors.amberAccent
                                : Colors.white,
                          ),
                        ),
                      ),
                      Tab(
                        height: 50,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: DNText(
                            title: '${store.boards.length} Boards',
                            fontSize: 25,
                            color: _tabController.index == 1
                                ? Colors.amberAccent
                                : Colors.white,
                          ),
                        ),
                      )
                    ],
                  );
                }),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: DNButton(
                          title: 'Active',
                          onClick: () =>
                              setState(() => store.isActiveTask = true),
                          isPrimary: store.isActiveTask,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: DNButton(
                          title: 'Done',
                          onClick: () =>
                              setState(() => store.isActiveTask = false),
                          isPrimary: !store.isActiveTask,
                        ),
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
                //
                // DAYS CALENDAR
                //
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      weekDaysSlice.length,
                      (index) {
                        final isToday = weekDaysSlice[currenWeekDayIndex - 1] ==
                            weekDaysSlice[index];
                        final computedDate = now.add(
                            Duration(days: index - (currenWeekDayIndex - 1)));
                        return GestureDetector(
                          onTap: () => setState(() {
                            if (currenWeekDayIndex - 1 == index) {
                              selectedDate = DateTime.now();
                            } else {
                              selectedDate = computedDate;
                            }
                          }),
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
                                                selectedDate.weekday - 1] ==
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
        ],
        body: Observer(builder: (_) {
          return TabBarView(
            controller: _tabController,
            children: [
              if (filteredTask(date: selectedDate, store: store).isNotEmpty)
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount:
                      filteredTask(date: selectedDate, store: store).length,
                  itemBuilder: (context, index) {
                    final task =
                        filteredTask(date: selectedDate, store: store)[index];
                    return InfoCard(data: task);
                  },
                ),
              if (filteredTask(date: selectedDate, store: store).isEmpty)
                const Center(
                  child: DNText(
                    title: 'Empty',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    opacity: .5,
                  ),
                ),
              if (store.boards.isNotEmpty)
                ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    itemCount: store.boards.length,
                    itemBuilder: (context, index) {
                      final board = store.boards[index];
                      return InfoCard(data: board);
                    }),
              if (store.boards.isEmpty)
                const Center(
                  child: DNText(
                    title: 'Empty',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    opacity: .5,
                  ),
                ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        clipBehavior: Clip.antiAlias,
        onPressed: () => showModalBottomSheetDN(context),
        child: InkWell(
          splashColor: Colors.white10,
          child: Ink(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: const AssetImage('assets/pattern.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.amberAccent.shade200, BlendMode.multiply)),
            ),
            child: const Icon(
              Icons.add,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic>? showModalBottomSheetDN(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: const Color.fromARGB(255, 35, 35, 35),
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(top: 60),
          child: const DNTTabBar(),
        ),
      );
    },
  );
}

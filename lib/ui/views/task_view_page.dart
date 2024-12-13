import 'package:calendar_flutter/store/board/board.dart';
import 'package:calendar_flutter/store/task/task.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/home.dart';
import 'package:calendar_flutter/ui/widgets/calendar.dart';
import 'package:calendar_flutter/ui/widgets/info_card.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

enum SampleItem { active, done }

class TaskViewPage extends StatefulWidget {
  const TaskViewPage({
    super.key,
  });

  @override
  State<TaskViewPage> createState() => _TaskViewStatePage();
}

class _TaskViewStatePage extends State<TaskViewPage>
    with SingleTickerProviderStateMixin {
  late final _tabController =
      TabController(length: 2, vsync: this, initialIndex: 0);
  late TaskStore _taskStore;
  late BoardStore _boardStore;
  final searchController = TextEditingController();
  final scrollController =
      ScrollController(initialScrollOffset: (now.month - 1) * 250);
  DateTime selectedDate = now;
  int currentMonthIndex = now.month - 1;
  bool isShowSearch = false;
  bool isOpenCalendar = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _taskStore = Provider.of<TaskStore>(context);
    _boardStore = Provider.of<BoardStore>(context);
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollController.dispose();
    _taskStore.isActiveTask = false;
    _taskStore.isAllTask = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isOpenCalendar ? 330 : 0,
            color: Colors.amberAccent,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const DNText(
                        title: '2024',
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          selectedDate = now;
                          currentMonthIndex = now.month - 1;
                          scrollController.animateTo((now.month - 1) * 250,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.bounceIn);
                        }),
                        child: const DNText(
                          title: 'Reset',
                          color: Colors.black,
                          fontSize: 20,
                          opacity: .5,
                        ),
                      ),
                    ],
                  ),
                  Calendar(
                    onClick: (DateTime day) => setState(() {
                      selectedDate = day;
                      isOpenCalendar = !isOpenCalendar;
                    }),
                    selectedDate: selectedDate,
                    controller: scrollController,
                  )
                ],
              ),
            ),
          ),
          Column(
            key: UniqueKey(),
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: isOpenCalendar ? 20 : 60.0,
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButton(
                      color: Colors.amberAccent,
                    ),
                    DNText(
                        title:
                            ' ${selectedDate.day} ${monthsFullNames[selectedDate.month - 1]}, ${selectedDate.year}'),
                    DNIconButton(
                      icon: const Icon(
                        Icons.calendar_month,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.amberAccent,
                      onClick: () =>
                          setState(() => isOpenCalendar = !isOpenCalendar),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: Colors.black,
                  elevation: 0,
                  pinned: false,
                  toolbarHeight: 0,
                  expandedHeight: 60,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(90),
                    child: SizedBox(),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                      children: [
                        TabBar(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              child: Observer(builder: (_) {
                                return DNText(
                                  // title:
                                  //     '${filteredTask(date: selectedDate, taskStore: _taskStore).length} Tasks',
                                  title: ' Tasks',
                                  fontSize: 25,
                                  color: _tabController.index == 0
                                      ? Colors.amberAccent
                                      : Colors.white,
                                );
                              }),
                            ),
                            Tab(
                              height: 50,
                              child: Observer(builder: (_) {
                                return DNText(
                                  title: '${_boardStore.board.length} Boards',
                                  fontSize: 25,
                                  color: _tabController.index == 1
                                      ? Colors.amberAccent
                                      : Colors.white,
                                );
                              }),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(top: 25),
                          child: Row(
                            children: [
                              if (isShowSearch)
                                Expanded(
                                    child: DNInput(
                                  title: 'Search',
                                  controller: searchController,
                                  onClick: (string) => setState(() {}),
                                )),
                              DNIconButton(
                                  icon: Icon(
                                    isShowSearch ? Icons.clear : Icons.search,
                                    color: Colors.black,
                                  ),
                                  onClick: () => setState(() {
                                        isShowSearch = !isShowSearch;
                                        searchController.clear();
                                      })),
                              if (!isShowSearch)
                                PopupMenuButton(
                                  icon: const Icon(
                                    Icons.filter_alt,
                                    color: Colors.black,
                                  ),
                                  style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Colors.amberAccent),
                                      foregroundColor:
                                          WidgetStatePropertyAll(Colors.white)),
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<SampleItem>>[
                                    PopupMenuItem<SampleItem>(
                                      value: SampleItem.active,
                                      onTap: () => setState(() =>
                                          _taskStore.isActiveTask = false),
                                      child: const DNText(
                                        title: 'Active',
                                        color: Colors.black,
                                      ),
                                    ),
                                    PopupMenuItem<SampleItem>(
                                      value: SampleItem.done,
                                      onTap: () => setState(
                                          () => _taskStore.isActiveTask = true),
                                      child: const DNText(
                                        title: 'Done',
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              if (!isShowSearch) Expanded(child: Container()),
                              if (!isShowSearch)
                                DNButton(
                                  title: 'All',
                                  onClick: () => setState(() => _taskStore
                                      .isAllTask = !_taskStore.isAllTask),
                                  isPrimary: _taskStore.isAllTask,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: TabBarView(
                controller: _tabController,
                children: [
                  SizedBox(),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //   child: CustomScrollView(
                  //     slivers: [
                  //       Observer(builder: (_) {
                  //         return SliverList(
                  //           delegate: SliverChildBuilderDelegate(
                  //             childCount: filteredTask(
                  //                     date: selectedDate,
                  //                     searchText: searchController.text,
                  //                     taskStore: _taskStore)
                  //                 .length,
                  //             (BuildContext context, int index) {
                  //               final task = filteredTask(
                  //                   date: selectedDate,
                  //                   searchText: searchController.text,
                  //                   taskStore: _taskStore)[index];
                  //               return InfoCard(
                  //                 data: task,
                  //               );
                  //             },
                  //           ),
                  //         );
                  //       }),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomScrollView(
                      slivers: [
                        Observer(builder: (_) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: _boardStore.board.length,
                              (context, index) {
                                final board = _boardStore.board[index];
                                return InfoCard(
                                  data: board,
                                );
                              },
                            ),
                          );
                        })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        onPressed: () => showModalBottomSheetDN(context),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}

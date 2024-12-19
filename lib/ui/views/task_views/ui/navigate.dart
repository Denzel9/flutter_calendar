import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task_views/store/task_views.dart';
import 'package:calendar_flutter/ui/views/task_views/task_view_page.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Navigate extends StatefulWidget {
  final bool innerBoxIsScrolled;
  final TabController controller;
  final TextEditingController searchController;
  const Navigate(
      {super.key,
      required this.controller,
      required this.searchController,
      required this.innerBoxIsScrolled});

  @override
  State<Navigate> createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final TaskViewsStoreLocal taskViewsStoreLocal =
        context.watch<TaskViewsStoreLocal>();
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      pinned: false,
      toolbarHeight: 0,
      expandedHeight: 60,
      floating: true,
      forceElevated: widget.innerBoxIsScrolled,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: SizedBox(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            TabBar(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              controller: widget.controller,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.amberAccent,
              unselectedLabelColor: Colors.white54,
              labelColor: Colors.amberAccent,
              overlayColor:
                  WidgetStateProperty.all(Colors.amberAccent.withOpacity(0.1)),
              tabs: [
                Tab(
                  height: 50,
                  child: Observer(builder: (_) {
                    return DNText(
                      title:
                          '${filteredTask(date: taskViewsStoreLocal.selectedDate, store: store).length} Tasks',
                      fontSize: 25,
                      color: widget.controller.index == 0
                          ? Colors.amberAccent
                          : Colors.white,
                    );
                  }),
                ),
                Tab(
                  height: 50,
                  child: Observer(builder: (_) {
                    return DNText(
                      title: '${store.boards.length} Boards',
                      fontSize: 25,
                      color: widget.controller.index == 1
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
                  if (taskViewsStoreLocal.isShowSearch)
                    Expanded(
                        child: DNInput(
                      title: 'Search',
                      controller: widget.searchController,
                      onClick: (string) => setState(() {}),
                    )),
                  DNIconButton(
                      icon: Icon(
                        taskViewsStoreLocal.isShowSearch
                            ? Icons.clear
                            : Icons.search,
                        color: Colors.black,
                      ),
                      onClick: () => setState(() {
                            taskViewsStoreLocal.isShowSearch =
                                !taskViewsStoreLocal.isShowSearch;
                            widget.searchController.clear();
                          })),
                  if (!taskViewsStoreLocal.isShowSearch)
                    PopupMenuButton(
                      icon: const Icon(
                        Icons.filter_alt,
                        color: Colors.black,
                      ),
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.amberAccent),
                          foregroundColor:
                              WidgetStatePropertyAll(Colors.white)),
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<SampleItem>>[
                        PopupMenuItem<SampleItem>(
                          value: SampleItem.active,
                          onTap: () =>
                              setState(() => store.isActiveTask = false),
                          child: const DNText(
                            title: 'Active',
                            color: Colors.black,
                          ),
                        ),
                        PopupMenuItem<SampleItem>(
                          value: SampleItem.done,
                          onTap: () =>
                              setState(() => store.isActiveTask = true),
                          child: const DNText(
                            title: 'Done',
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  if (!taskViewsStoreLocal.isShowSearch)
                    Expanded(child: Container()),
                  if (!taskViewsStoreLocal.isShowSearch)
                    DNButton(
                      title: 'All',
                      onClick: () =>
                          setState(() => store.isAllTask = !store.isAllTask),
                      isPrimary: store.isAllTask,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/viewing/store/viewing.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

enum SampleItem { active, done, all }

class Navigate extends StatefulWidget {
  final bool innerBoxIsScrolled;
  final TabController controller;
  const Navigate(
      {super.key, required this.controller, required this.innerBoxIsScrolled});

  @override
  State<Navigate> createState() => _NavigateState();
}

class _NavigateState extends State<Navigate> {
  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final ViewingStoreLocal taskViewsStoreLocal =
        context.watch<ViewingStoreLocal>();

    return Observer(
      builder: (_) {
        final tasks = filteredTask(
          searchText: taskViewsStoreLocal.searchtext,
          isAllTask: taskViewsStoreLocal.isAllTask,
          isActiveTask: taskViewsStoreLocal.isActiveTask,
          isArchive: !taskViewsStoreLocal.isActiveTask,
          isCollaborationTasks: taskViewsStoreLocal.isCollaboration,
          store: store,
        );

        return SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          pinned: false,
          toolbarHeight: 0,
          expandedHeight: 120,
          bottom: const PreferredSize(
            preferredSize: Size(100, 100),
            child: SizedBox(),
          ),
          floating: true,
          forceElevated: widget.innerBoxIsScrolled,
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
                  onTap: (value) => setState(() {
                    taskViewsStoreLocal.isShowSearch = false;
                  }),
                  tabs: [
                    Tab(
                      child: DNText(
                        title: '${tasks.length} Tasks',
                        fontSize: 25,
                        color: widget.controller.index == 0
                            ? Colors.amberAccent
                            : Colors.white,
                      ),
                    ),
                    Tab(
                      child: DNText(
                        title: '${store.boards.length} Boards',
                        fontSize: 25,
                        color: widget.controller.index == 1
                            ? Colors.amberAccent
                            : Colors.white,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      if (taskViewsStoreLocal.isShowSearch)
                        Expanded(
                            child: SizedBox(
                          height: 50,
                          child: DNInput(
                            title: 'Search',
                            autoFocus: taskViewsStoreLocal.isShowSearch,
                            onChanged: (string) => setState(() {
                              taskViewsStoreLocal.searchtext = string;
                            }),
                            onSubmitted: (string) => setState(() {
                              taskViewsStoreLocal.isShowSearch = false;
                            }),
                          ),
                        )),
                      DNIconButton(
                        icon: Icon(
                          taskViewsStoreLocal.isShowSearch
                              ? Icons.clear
                              : taskViewsStoreLocal.searchtext.isNotEmpty
                                  ? Icons.clear
                                  : Icons.search,
                          color: Colors.black,
                        ),
                        onClick: () => setState(() {
                          if (taskViewsStoreLocal.searchtext.isNotEmpty) {
                            taskViewsStoreLocal.isShowSearch = false;
                          } else {
                            taskViewsStoreLocal.isShowSearch =
                                !taskViewsStoreLocal.isShowSearch;
                          }
                          taskViewsStoreLocal.searchtext = '';
                        }),
                      ),
                      if (!taskViewsStoreLocal.isShowSearch &&
                          widget.controller.index == 0)
                        Stack(
                          children: [
                            PopupMenuButton(
                              color: Theme.of(context).primaryColorDark,
                              icon: const Icon(
                                Icons.filter_alt,
                                color: Colors.black,
                              ),
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.amberAccent),
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white),
                              ),
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  value: SampleItem.active,
                                  onTap: () => setState(
                                    () =>
                                        taskViewsStoreLocal.isActiveTask = true,
                                  ),
                                  child: DNText(
                                    title:
                                        'Opened ${store.listActiveTask.length}',
                                    color: taskViewsStoreLocal.isActiveTask
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                  ),
                                ),
                                PopupMenuItem(
                                  value: SampleItem.done,
                                  onTap: () => setState(
                                    () => taskViewsStoreLocal.isActiveTask =
                                        false,
                                  ),
                                  child: DNText(
                                    title:
                                        'Closed ${store.listArchiveTasks.length}',
                                    color: !taskViewsStoreLocal.isActiveTask
                                        ? Theme.of(context).primaryColor
                                        : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            if (store.listArchiveTasks.isNotEmpty)
                              Positioned(
                                right: 5,
                                top: 3,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                          ],
                        ),
                      if (!taskViewsStoreLocal.isShowSearch &&
                          widget.controller.index == 0)
                        DNIconButton(
                          icon: Icon(Icons.people,
                              color: taskViewsStoreLocal.isCollaboration
                                  ? Colors.black
                                  : Colors.white),
                          onClick: () => setState(() {
                            taskViewsStoreLocal.isCollaboration =
                                !taskViewsStoreLocal.isCollaboration;
                          }),
                          backgroundColor: taskViewsStoreLocal.isCollaboration
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                        ),
                      if (!taskViewsStoreLocal.isShowSearch)
                        Expanded(child: Container()),
                      if (!taskViewsStoreLocal.isShowSearch &&
                          widget.controller.index == 0)
                        DNButton(
                          title: 'All',
                          onClick: () => setState(() {
                            taskViewsStoreLocal.isAllTask =
                                !taskViewsStoreLocal.isAllTask;
                            taskViewsStoreLocal.isActiveTask = true;
                          }),
                          isPrimary: taskViewsStoreLocal.isAllTask,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

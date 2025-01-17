import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task_views/store/task_views.dart';
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
    final TaskViewsStoreLocal taskViewsStoreLocal =
        context.watch<TaskViewsStoreLocal>();

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
                    setState(() {
                      taskViewsStoreLocal.isShowSearch = false;
                    });
                  }),
                  overlayColor: WidgetStateProperty.all(
                      Colors.amberAccent.withOpacity(0.1)),
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
                            onClick: (string) => setState(() {
                              taskViewsStoreLocal.searchtext = string;
                            }),
                          ),
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
                          taskViewsStoreLocal.searchtext = '';
                        }),
                      ),
                      if (!taskViewsStoreLocal.isShowSearch &&
                          widget.controller.index == 0)
                        PopupMenuButton(
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
                                () => taskViewsStoreLocal.isActiveTask = true,
                              ),
                              child: DNText(
                                title: 'Active',
                                color: taskViewsStoreLocal.isActiveTask
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                            ),
                            PopupMenuItem(
                              value: SampleItem.done,
                              onTap: () => setState(
                                () => taskViewsStoreLocal.isActiveTask = false,
                              ),
                              child: DNText(
                                title: 'Archive',
                                color: !taskViewsStoreLocal.isActiveTask
                                    ? Theme.of(context).primaryColor
                                    : Colors.black,
                              ),
                            ),
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
                          onClick: () => setState(() => taskViewsStoreLocal
                              .isAllTask = !taskViewsStoreLocal.isAllTask),
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

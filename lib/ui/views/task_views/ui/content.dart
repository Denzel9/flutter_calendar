import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/task_views/store/task_views.dart';
import 'package:calendar_flutter/ui/widgets/info_card.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Content extends StatelessWidget {
  final TabController controller;
  const Content({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final TaskViewsStoreLocal taskViewsStoreLocal =
        context.watch<TaskViewsStoreLocal>();
    final AppStore store = context.watch<AppStore>();

    return TabBarView(
      controller: controller,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomScrollView(
            slivers: [
              Observer(
                builder: (_) {
                  final tasks = filteredTask(
                    searchText: taskViewsStoreLocal.searchtext,
                    isAllTask: taskViewsStoreLocal.isAllTask,
                    isActiveTask: taskViewsStoreLocal.isActiveTask,
                    isArchive: !taskViewsStoreLocal.isActiveTask,
                    isCollaborationTasks: taskViewsStoreLocal.isCollaboration,
                    store: store,
                  );

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: tasks.length,
                      (BuildContext context, int index) {
                        final task = tasks[index];
                        return InfoCard(
                          data: task,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomScrollView(
            slivers: [
              Observer(builder: (_) {
                final boards = filteredBoards(
                  store.boards,
                  taskViewsStoreLocal.searchtext,
                );
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: boards.length,
                    (context, index) {
                      final board = boards[index];
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
    );
  }
}

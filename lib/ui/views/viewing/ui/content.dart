import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/viewing/store/viewing.dart';
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
    final ViewingStoreLocal taskViewsStoreLocal =
        context.watch<ViewingStoreLocal>();
    final AppStore store = context.watch<AppStore>();

    return Observer(builder: (_) {
      final List<TaskModel> tasks = filteredTask(
        searchText: taskViewsStoreLocal.searchtext,
        isAllTask: taskViewsStoreLocal.isAllTask,
        isActiveTask: taskViewsStoreLocal.isActiveTask,
        isArchive: !taskViewsStoreLocal.isActiveTask,
        isCollaborationTasks: taskViewsStoreLocal.isCollaboration,
        store: store,
      );
      return TabBarView(
        controller: controller,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: tasks.isNotEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: tasks.length,
                          (BuildContext context, int index) {
                            final task = tasks[index];
                            return InfoCard(
                              data: task,
                              index: index,
                            );
                          },
                        ),
                      )
                    ],
                  )
                : const Center(
                    child: DNText(
                      title: 'Empty',
                      opacity: .5,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: store.boards.isNotEmpty
                ? CustomScrollView(
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
                                index: index,
                              );
                            },
                          ),
                        );
                      })
                    ],
                  )
                : const Center(
                    child: DNText(
                      title: 'Empty',
                      opacity: .5,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
          )
        ],
      );
    });
  }
}

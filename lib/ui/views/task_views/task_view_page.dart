import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/home/ui/action_button.dart';
import 'package:calendar_flutter/ui/views/task_views/store/task_views.dart';
import 'package:calendar_flutter/ui/views/task_views/ui/content.dart';
import 'package:calendar_flutter/ui/views/task_views/ui/header_calendar.dart';
import 'package:calendar_flutter/ui/views/task_views/ui/navigate.dart';
import 'package:flutter/material.dart';
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
  final searchController = TextEditingController();

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    return Provider(
      create: (context) => TaskViewsStoreLocal(),
      child: Scaffold(
        body: Column(
          children: [
            HeaderCalendar(tasks: store.tasks),
            Expanded(
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  Navigate(
                    controller: _tabController,
                    searchController: searchController,
                    innerBoxIsScrolled: innerBoxIsScrolled,
                  )
                ],
                body: Content(
                  controller: _tabController,
                  searchController: searchController,
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
      ),
    );
  }
}

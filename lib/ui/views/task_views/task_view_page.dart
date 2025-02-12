import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/task_views/store/task_views.dart';
import 'package:calendar_flutter/ui/views/task_views/ui/content.dart';
import 'package:calendar_flutter/ui/views/task_views/ui/header_calendar.dart';
import 'package:calendar_flutter/ui/views/task_views/ui/navigate.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskViewPage extends StatefulWidget {
  final DateTime? date;
  const TaskViewPage({super.key, this.date});

  @override
  State<TaskViewPage> createState() => _TaskViewStatePage();
}

class _TaskViewStatePage extends State<TaskViewPage>
    with SingleTickerProviderStateMixin {
  late final _tabController =
      TabController(length: 2, vsync: this, initialIndex: 0);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>()
      ..selectedDate = widget.date != null ? widget.date! : now;

    return Provider(
      create: (context) => TaskViewsStoreLocal(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              HeaderCalendar(
                tasks: store.tasks,
                controller: _tabController,
              ),
              Expanded(
                child: NestedScrollView(
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    Navigate(
                      controller: _tabController,
                      innerBoxIsScrolled: innerBoxIsScrolled,
                    )
                  ],
                  body: Content(
                    controller: _tabController,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          clipBehavior: Clip.antiAlias,
          onPressed: () => Navigator.pushNamed(context, routesList.create),
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
                      Colors.amberAccent.shade200, BlendMode.multiply),
                ),
              ),
              child: const Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

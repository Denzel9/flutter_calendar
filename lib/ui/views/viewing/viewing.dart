import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/viewing/store/viewing.dart';
import 'package:calendar_flutter/ui/views/viewing/ui/content.dart';
import 'package:calendar_flutter/ui/views/viewing/ui/header_calendar.dart';
import 'package:calendar_flutter/ui/views/viewing/ui/navigate.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class ViewingPage extends StatefulWidget {
  final DateTime? date;
  const ViewingPage({super.key, this.date});

  @override
  State<ViewingPage> createState() => _TaskViewStatePage();
}

class _TaskViewStatePage extends State<ViewingPage>
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
      create: (context) => ViewingStoreLocal(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              HeaderCalendar(
                tasks: store.tasks,
                controller: _tabController,
              ),
              Expanded(child: Observer(builder: (context) {
                final ViewingStoreLocal taskViewsStoreLocal =
                    context.read<ViewingStoreLocal>();
                return GestureDetector(
                  onTap: () {
                    if (taskViewsStoreLocal.isOpenCalendar) {
                      setState(() {
                        taskViewsStoreLocal.isOpenCalendar = false;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: taskViewsStoreLocal.isOpenCalendar,
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
                );
              })),
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

import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/home/ui/action_button.dart';
import 'package:calendar_flutter/ui/views/home/ui/content.dart';
import 'package:calendar_flutter/ui/views/home/ui/content_sliver.dart';
import 'package:calendar_flutter/ui/views/home/ui/info_sliver.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    context.watch<AppStore>().selectedDate = now;
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();
    return Scaffold(
      body: Observer(builder: (_) {
        return NestedScrollView(
          scrollBehavior: store.todayTasks.isEmpty
              ? const MaterialScrollBehavior().copyWith(
                  physics: const NeverScrollableScrollPhysics(),
                  dragDevices: {},
                )
              : null,
          headerSliverBuilder: (context, _) =>
              [const InfoSliver(), ContentSliver(controller: tabController)],
          body: Content(controller: tabController),
        );
      }),
      floatingActionButton: const ActionButton(),
    );
  }
}

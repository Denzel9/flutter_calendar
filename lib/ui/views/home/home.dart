import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/home/store/home.dart';
import 'package:calendar_flutter/ui/views/home/ui/action_button.dart';
import 'package:calendar_flutter/ui/views/home/ui/board_tab.dart';
import 'package:calendar_flutter/ui/views/home/ui/tabs_sliver.dart';
import 'package:calendar_flutter/ui/views/home/ui/info_sliver.dart';
import 'package:calendar_flutter/ui/views/home/ui/task_tab.dart';
import 'package:flutter/material.dart';
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
  void didChangeDependencies() {
    final store = context.read<AppStore>();
    store.initState();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => HomeStoreLocal(),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, _) =>
              [const InfoSliver(), TabsSliver(controller: tabController)],
          body: TabBarView(
            controller: tabController,
            children: const [TaskTab(), BoardTab()],
          ),
        ),
        floatingActionButton: const ActionButton(),
      ),
    );
  }
}

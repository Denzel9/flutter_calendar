import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/store/main/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class TabsSliver extends StatefulWidget {
  final TabController controller;
  const TabsSliver({
    super.key,
    required this.controller,
  });

  @override
  State<TabsSliver> createState() => _TabsSliverState();
}

class _TabsSliverState extends State<TabsSliver> {
  final routesList = Routes();

  @override
  Widget build(BuildContext context) {
    final store = context.watch<AppStore>();

    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColorDark,
      surfaceTintColor: Colors.white,
      elevation: 0,
      pinned: true,
      toolbarHeight: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Observer(
          builder: (_) {
            return TabBar(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onTap: (_) => setState(() {}),
              controller: widget.controller,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.amberAccent,
              unselectedLabelColor: Colors.white54,
              labelColor: Colors.amberAccent,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              tabs: [
                Tab(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DNText(
                      title: '${store.todayTasks.length} Tasks',
                      fontSize: 25,
                      color: widget.controller.index == 0
                          ? Colors.amberAccent
                          : Colors.white,
                    ),
                  ),
                ),
                Tab(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DNText(
                      title: '${store.boards.length} Boards',
                      fontSize: 25,
                      color: widget.controller.index == 1
                          ? Colors.amberAccent
                          : Colors.white,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

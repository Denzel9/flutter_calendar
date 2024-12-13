import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/widgets/form.dart';
import 'package:calendar_flutter/utils/data_creator.dart';
import 'package:flutter/material.dart';

class DNTTabBar extends StatefulWidget {
  final int? countTask;
  final int? countBoards;

  const DNTTabBar({
    super.key,
    this.countTask,
    this.countBoards,
  });

  @override
  State<DNTTabBar> createState() => _TabBarState();
}

class _TabBarState extends State<DNTTabBar>
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
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          onTap: (value) => setState(() {}),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.amberAccent,
          unselectedLabelColor: Colors.white54,
          labelColor: Colors.amberAccent,
          overlayColor:
              WidgetStateProperty.all(Colors.amberAccent.withOpacity(0.1)),
          tabs: [
            Tab(
                height: 50,
                child: DNText(
                  title: 'Tasks',
                  fontSize: 20,
                  color: _tabController.index == 0
                      ? Colors.amberAccent
                      : Colors.white,
                )),
            Tab(
              height: 50,
              child: DNText(
                title: 'Boards',
                fontSize: 20,
                color: _tabController.index == 1
                    ? Colors.amberAccent
                    : Colors.white,
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const DNForm(isTask: true),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const DNForm(isTask: false),
              ),
            ],
          ),
        ),
        DNButton(
          title: 'Add',
          onClick: () {
            _tabController.index == 0 ? addTask() : addBoard();
            Navigator.pop(context);
            // selectedDate = now;
          },
          isPrimary: true,
        ),
      ],
    );
  }
}

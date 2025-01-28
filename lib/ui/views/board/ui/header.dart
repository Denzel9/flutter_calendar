import 'package:calendar_flutter/store/main/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  final String title;
  final int countTask;
  final TabController controller;

  const Header({
    super.key,
    required this.controller,
    required this.title,
    required this.countTask,
  });

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DNIconButton(
                  icon: const Icon(
                    Icons.arrow_downward,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.amberAccent,
                  onClick: () => Navigator.pop(context)),
            ],
          ),
        ),
        TabBar(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          controller: widget.controller,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Colors.amberAccent,
          unselectedLabelColor: Colors.white54,
          labelColor: Colors.amberAccent,
          overlayColor:
              WidgetStateProperty.all(Colors.amberAccent.withOpacity(0.1)),
          tabs: [
            Observer(
              builder: (_) {
                return Tab(
                  height: 50,
                  child: DNText(
                    title:
                        '${filteredTaskToBoard(widget.title, store.tasks).length} Tasks',
                    fontSize: 25,
                    color: widget.controller.index == 0
                        ? Colors.amberAccent
                        : Colors.white,
                  ),
                );
              },
            ),
            Tab(
              height: 50,
              child: DNText(
                title: 'Information',
                fontSize: 25,
                color: widget.controller.index == 1
                    ? Colors.amberAccent
                    : Colors.white,
              ),
            )
          ],
        ),
      ],
    );
  }
}

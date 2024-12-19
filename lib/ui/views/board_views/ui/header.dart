import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/board_views/board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  final TabController controller;

  const Header({
    super.key,
    required this.controller,
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
              PopupMenuButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
                    foregroundColor: WidgetStatePropertyAll(Colors.black)),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: SampleItem.delete,
                    onTap: () {
                      // taskService.dele(widget.board.docId);
                      Navigator.pop(context);
                    },
                    child: const DNText(
                      title: 'Delete',
                      color: Colors.black,
                    ),
                  ),
                  PopupMenuItem(
                    value:
                        store.isAllTask ? SampleItem.active : SampleItem.done,
                    onTap: () => setState(
                        () => store.isActiveTask = !store.isActiveTask),
                    child: DNText(
                      title: store.isActiveTask ? "Done" : 'Active',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
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
            Observer(builder: (_) {
              return Tab(
                height: 50,
                child: DNText(
                  title: '${store.tasks.length} Tasks',
                  fontSize: 25,
                  color: widget.controller.index == 0
                      ? Colors.amberAccent
                      : Colors.white,
                ),
              );
            }),
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

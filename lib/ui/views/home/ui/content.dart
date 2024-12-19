import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/widgets/info_card.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Content extends StatefulWidget {
  final TabController controller;
  const Content({super.key, required this.controller});

  @override
  State<Content> createState() => _ContentSliverState();
}

class _ContentSliverState extends State<Content> {
  final routesList = Routes();
  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    return Observer(
      builder: (_) {
        return TabBarView(
          controller: widget.controller,
          children: [
            if (filteredTask(date: store.selectedDate, store: store).isNotEmpty)
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                itemCount:
                    filteredTask(date: store.selectedDate, store: store).length,
                itemBuilder: (context, index) {
                  final task = filteredTask(
                      date: store.selectedDate, store: store)[index];
                  return InfoCard(data: task);
                },
              ),
            if (filteredTask(date: store.selectedDate, store: store).isEmpty)
              const Center(
                child: DNText(
                  title: 'Empty',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  opacity: .5,
                ),
              ),
            if (store.boards.isNotEmpty)
              ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: store.boards.length,
                  itemBuilder: (context, index) {
                    final board = store.boards[index];
                    return InfoCard(data: board);
                  }),
            if (store.boards.isEmpty)
              const Center(
                child: DNText(
                  title: 'Empty',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  opacity: .5,
                ),
              ),
          ],
        );
      },
    );
  }
}

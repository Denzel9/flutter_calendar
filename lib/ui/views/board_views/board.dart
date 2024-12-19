import 'package:calendar_flutter/ui/views/board_views/ui/content.dart';
import 'package:calendar_flutter/ui/views/board_views/ui/header.dart';
import 'package:calendar_flutter/ui/views/board_views/ui/information.dart';
import 'package:flutter/material.dart';
import '../../../models/board.dart';

enum SampleItem { delete, active, done }

class BoardViewPage extends StatefulWidget {
  final Board board;

  const BoardViewPage({super.key, required this.board});

  @override
  State<BoardViewPage> createState() => _BoardViewStatePage();
}

class _BoardViewStatePage extends State<BoardViewPage>
    with SingleTickerProviderStateMixin {
  late final tabController =
      TabController(length: 2, vsync: this, initialIndex: 0);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: .7,
      maxChildSize: 1,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.only(top: 80),
        decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              controller: tabController,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  Content(
                    controller: scrollController,
                    title: widget.board.title,
                  ),
                  Information(
                    title: widget.board.title,
                    createdAt: widget.board.createdAt,
                    description: widget.board.description,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

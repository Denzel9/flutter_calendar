import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/service/board/board_service_impl.dart';
import 'package:calendar_flutter/ui/views/board/ui/content.dart';
import 'package:calendar_flutter/ui/views/board/ui/header.dart';
import 'package:calendar_flutter/ui/views/board/ui/information.dart';
import 'package:flutter/material.dart';

enum SampleItem { delete, active, done }

class BoardViewPage extends StatefulWidget {
  final String id;

  const BoardViewPage({
    super.key,
    required this.id,
  });

  @override
  State<BoardViewPage> createState() => _BoardViewStatePage();
}

class _BoardViewStatePage extends State<BoardViewPage>
    with SingleTickerProviderStateMixin {
  final BoardServiceImpl boardService = BoardServiceImpl(firestore);
  late final tabController =
      TabController(length: 2, vsync: this, initialIndex: 0);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    if (context.mounted) {
      tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: DraggableScrollableSheet(
        initialChildSize: 1,
        minChildSize: .7,
        maxChildSize: 1,
        expand: false,
        builder: (context, scrollController) => StreamBuilder(
          stream: boardService.getBoard(widget.id),
          builder: (context, snapshot) {
            final Board board = Board.fromJsonWithId(
                snapshot.data?.data(), snapshot.data?.id ?? '');
            return SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.only(top: 60),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      controller: tabController,
                      title: board.title,
                      countTask: board.tasks.length,
                      id: widget.id,
                      scaffoldKey: scaffoldKey,
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: [
                          Content(
                            controller: scrollController,
                            title: board.title,
                          ),
                          Information(
                            board: board,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

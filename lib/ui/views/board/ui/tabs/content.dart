import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/board/store/board.dart';
import 'package:calendar_flutter/ui/views/board/ui/task_card.dart';
import 'package:calendar_flutter/ui/views/create/create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Content extends StatefulWidget {
  final String title;

  const Content({
    super.key,
    required this.title,
  });

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> with AutomaticKeepAliveClientMixin {
  late final BoardStoreLocal boardStoreLocal;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final BoardStoreLocal boardStoreLocal = context.watch<BoardStoreLocal>();
    super.build(context);
    return boardStoreLocal.tasks.isNotEmpty
        ? Observer(
            builder: (_) => ListView.builder(
              itemCount: boardStoreLocal.tasks.length,
              itemBuilder: (context, index) {
                final task = boardStoreLocal.tasks[index];
                return TaskCard(
                  task: task,
                  index: index,
                );
              },
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DNText(
                title: 'Empty',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                opacity: .5,
              ),
              const SizedBox(
                height: 10,
              ),
              DNButton(
                title: 'Add task',
                isPrimary: false,
                onClick: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePage(
                      selectedBoard: widget.title,
                    ),
                  ),
                ),
              )
            ],
          );
  }
}

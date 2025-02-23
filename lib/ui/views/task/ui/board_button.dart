import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/animate/slide.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/board/board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardButton extends StatefulWidget {
  final String board;
  final String taskId;
  final List<Board> boards;

  const BoardButton({
    super.key,
    required this.board,
    required this.boards,
    required this.taskId,
  });

  @override
  State<BoardButton> createState() => _BoardButtonState();
}

class _BoardButtonState extends State<BoardButton> {
  @override
  Widget build(BuildContext context) {
    final String userId =
        context.select<AppStore, String>((store) => store.user.docId ?? '');

    return SlideAnimation(
      begin: const Offset(-1, 0),
      widget: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: GestureDetector(
            onTap: () {
              if (widget.taskId == userId) {
                final docId = widget.boards
                    .firstWhere((element) => element.title == widget.board)
                    .docId;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => BoardViewPage(id: docId ?? ''),
                );
              }
            },
            child: Chip(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 7,
              ),
              backgroundColor: Theme.of(context).primaryColorDark,
              side: BorderSide(color: Theme.of(context).primaryColor),
              shape: OutlinedBorder.lerp(
                  const RoundedRectangleBorder(),
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  1),
              label: DNText(
                color: Theme.of(context).primaryColor,
                title: widget.board,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

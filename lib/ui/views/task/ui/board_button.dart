import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/ui/components/animate/slide.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/board/board.dart';
import 'package:flutter/material.dart';

class BoardButton extends StatefulWidget {
  final String board;
  final List<Board> boards;
  const BoardButton({super.key, required this.board, required this.boards});

  @override
  State<BoardButton> createState() => _BoardButtonState();
}

class _BoardButtonState extends State<BoardButton> {
  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      begin: const Offset(-1, 0),
      widget: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: GestureDetector(
            onTap: () {
              final docId = widget.boards
                  .where((element) => element.title == widget.board)
                  .first
                  .docId;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => BoardViewPage(id: docId ?? ''),
              );
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

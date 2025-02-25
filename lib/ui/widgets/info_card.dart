import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/animate/slide.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/board/board.dart';
import 'package:calendar_flutter/ui/views/task/task.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/get_colors_tasks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoCard extends StatefulWidget {
  final dynamic data;
  final int? index;

  const InfoCard({
    super.key,
    required this.data,
    this.index,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String assignTitle(String ownerId) {
    final String author =
        widget.data.userId == ownerId ? 'me' : widget.data.author;
    return widget.data is TaskModel && widget.data.isCollaborated
        ? 'Assigned by $author'
        : '';
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();

    return SlideAnimation(
      controller: _controller,
      delay: Duration(
          milliseconds: widget.index != null ? widget.index! * 100 : 0),
      begin: const Offset(0, 3),
      widget: GestureDetector(
        onTap: () {
          widget.data is TaskModel
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskPage(id: widget.data.docId),
                  ),
                )
              : showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => BoardViewPage(id: widget.data.docId),
                );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColorDark,
            border: Border(
              left: BorderSide(
                color: widget.data is TaskModel
                    ? getColorTasks(widget.data.board)
                    : Colors.white,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      DNText(
                        title: widget.data is TaskModel
                            ? widget.data.board
                            : '${widget.data.tasks.length} Tasks',
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      DNText(
                        title: assignTitle(store.user.docId ?? ''),
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      DNText(
                        title: widget.data is TaskModel
                            ? getFormatTime(widget.data.date)
                            : getFormatDate(widget.data.createdAt),
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              DNText(
                title: widget.data.title,
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

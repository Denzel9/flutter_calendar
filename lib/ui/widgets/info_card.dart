import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/board_views/board.dart';
import 'package:calendar_flutter/ui/views/task/task.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/get_colors_tasks.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatefulWidget {
  final dynamic data;

  const InfoCard({
    super.key,
    required this.data,
  });

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => widget.data is Task
            ? TaskPage(task: widget.data)
            : BoardViewPage(board: widget.data),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        margin: const EdgeInsets.only(bottom: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColorDark,
          border: Border(
            left: BorderSide(
              color: widget.data is Task
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
                DNText(
                  title: widget.data is Task ? widget.data.board : '',
                  color: Colors.white,
                  fontSize: 18,
                ),
                Row(
                  children: [
                    DNText(
                      title: widget.data is Task
                          ? getFormatTime(widget.data.date)
                          : getFormatDate(widget.data.createdAt),
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.av_timer,
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
    );
  }
}

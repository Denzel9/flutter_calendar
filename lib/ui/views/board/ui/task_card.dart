import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/ui/components/animate/slide.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/task/task.dart';
import 'package:calendar_flutter/ui/widgets/avatar.dart';
import 'package:calendar_flutter/ui/widgets/badge.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/get_colors_tasks.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  final int? index;

  const TaskCard({
    super.key,
    required this.task,
    this.index,
  });

  @override
  State<TaskCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    return SlideAnimation(
      controller: _controller,
      delay: Duration(
          milliseconds: widget.index != null ? widget.index! * 100 : 0),
      begin: const Offset(0, 3),
      widget: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskPage(id: widget.task.docId ?? ''),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: const EdgeInsets.only(bottom: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColorDark,
            border: Border(
              left: BorderSide(color: getColorTasks(widget.task.board)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      DNText(
                        title: '12 Subtasks',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  DNText(
                    title: getFormatDate(widget.task.date),
                    color: Colors.white,
                    fontSize: 15,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              DNText(
                title: widget.task.title,
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  if (widget.task.isCollaborated) ...[
                    SizedBox(
                      height: 30,
                      width: widget.task.assign.length * 25,
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: List.generate(
                          widget.task.assign.length,
                          (index) => Positioned(
                            left: index * 15,
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: DNAvatar(url: widget.task.assign[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const DNBadge(title: 'Assigned'),
                    const SizedBox(width: 10),
                  ],
                  DNBadge(title: taskStatus[widget.task.status]),
                  const Expanded(child: SizedBox()),
                  if (isToday(widget.task.date))
                    DNBadge(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      icon: const Icon(
                        Icons.local_fire_department_outlined,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

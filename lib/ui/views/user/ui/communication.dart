import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/lib/show_bottom_sheet.dart';
import 'package:flutter/material.dart';

class Communication extends StatefulWidget {
  final String userId;
  final int followersCount;
  final int followingCount;

  const Communication({
    super.key,
    required this.userId,
    required this.followersCount,
    required this.followingCount,
  });

  @override
  State<Communication> createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> {
  late Future<int> getTasksCount;

  @override
  void initState() {
    getTasksCount = taskService.getTasksCount(widget.userId);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant Communication oldWidget) {
    if (oldWidget.userId != widget.userId) {
      getTasksCount = taskService.getTasksCount(widget.userId);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                splashColor: Colors.transparent,
                onTap: () => showFollowBottomSheet(
                  context: context,
                  isFollowers: true,
                  usersId: widget.userId,
                ).then((_) => setState(() {})),
                contentPadding: EdgeInsets.zero,
                title: const DNText(
                  title: 'Followers',
                  opacity: .5,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: DNText(
                    title: widget.followersCount.toString(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                splashColor: Colors.transparent,
                onTap: () => showFollowBottomSheet(
                  context: context,
                  isFollowers: false,
                  usersId: widget.userId,
                ).then((_) => setState(() {})),
                contentPadding: EdgeInsets.zero,
                title: const DNText(
                  title: 'Following',
                  opacity: .5,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: DNText(
                    title: widget.followingCount.toString(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getTasksCount,
                initialData: '0',
                builder: (context, snap) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const DNText(
                      title: 'Tasks',
                      opacity: .5,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: DNText(
                        title: snap.data.toString(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
}

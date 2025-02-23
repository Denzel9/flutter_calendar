import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/image.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Statistic extends StatefulWidget {
  const Statistic({super.key});

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  late final AppStore store;
  int attachmentsCount = 0;

  @override
  void didChangeDependencies() async {
    store = context.watch<AppStore>();
    for (final task in store.tasks) {
      taskService.getAttachments(task.docId ?? '').then((value) {
        setState(() {
          attachmentsCount += value.length;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .46,
          height: 210,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const DNText(
                title: 'Collaborated users',
                opacity: .5,
              ),
              store.user.followers.isNotEmpty &&
                      store.listAllCollaborationTask.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 40,
                          width: 80,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: List.generate(
                              store.user.followers.length,
                              (index) {
                                return FutureBuilder(
                                  future: userService
                                      .getAvatar(store.user.followers[index]),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final String? avatarUrl = snapshot.data;
                                      if (avatarUrl == null ||
                                          avatarUrl.isEmpty) {
                                        return Positioned(
                                          left: index.toDouble() * 15,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            child: const Icon(Icons.person),
                                          ),
                                        );
                                      }
                                      return Positioned(
                                        left: index.toDouble() * 15,
                                        child: ClipOval(
                                          child: DNImage(
                                            url: avatarUrl,
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Positioned(
                                        left: index.toDouble() * 15,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          child: const Icon(Icons.person),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        if (store.user.followers.length > 3)
                          SizedBox(
                            child: DNText(
                              title:
                                  '+ ${store.user.followers.length - 3} users',
                              fontSize: 14,
                            ),
                          )
                      ],
                    )
                  : const DNText(
                      title: 'Empty',
                      opacity: .5,
                    )
            ],
          ),
        ),
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .46,
              height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DNText(
                    title: 'Attachments',
                    opacity: .5,
                  ),
                  DNText(
                    title: attachmentsCount.toString(),
                    opacity: .5,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: MediaQuery.of(context).size.width * .46,
              height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DNText(
                    title: 'Collaborated tasks',
                    opacity: .5,
                  ),
                  DNText(
                    title: store.listAllCollaborationTask.length.toString(),
                    opacity: .5,
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

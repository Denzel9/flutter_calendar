import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/service/notification/notification_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InfoSliver extends StatelessWidget {
  const InfoSliver({super.key});

  int getPercent(List<Task> tasks) {
    if (tasks.isNotEmpty) {
      final completedTask = tasks.where((task) => task.done).length;
      return (completedTask * 100 / tasks.length).ceil();
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final routesList = Routes();
    final AppStore store = context.watch<AppStore>();
    final NotificationServiceImpl notificationService =
        NotificationServiceImpl();

    return SliverAppBar(
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      surfaceTintColor: Colors.white,
      elevation: 0,
      pinned: true,
      toolbarHeight: 0,
      expandedHeight: 310,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 60.0,
                left: 10,
                right: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const UserPage();
                        },
                      ),
                    ),
                    child: Observer(
                      builder: (_) {
                        return FutureBuilder(
                          future:
                              userService.getAvatar(store.user?.docId ?? ''),
                          builder: (context, snap) {
                            if (snap.hasData) {
                              return Skeletonizer(
                                enabled: !snap.hasData,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: snap.data ?? '',
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              );
                            } else {
                              return const Skeletonizer(
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      DNIconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onClick: () =>
                            Navigator.pushNamed(context, routesList.search),
                      ),
                      StreamBuilder(
                        stream:
                            notificationService.get(store.user?.docId ?? ''),
                        builder: (context, snapshot) => Stack(
                          children: [
                            Positioned(
                              child: DNIconButton(
                                icon: const Icon(
                                  Icons.notifications,
                                  color: Colors.black,
                                ),
                                onClick: () => Navigator.pushNamed(
                                    context, routesList.notification),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.red,
                                ),
                                child: Center(
                                    child: DNText(
                                  title:
                                      snapshot.data?.docs.length.toString() ??
                                          '0',
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DNText(
                    title: 'Good',
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  DNText(
                    title: getDayTitle(),
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: DNText(title: "Today's $weekDayName"),
                    subtitle: DNText(
                      title: "$monthSlice $currenDay, $currenYear",
                      fontSize: 15,
                      opacity: .5,
                    ),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: ListTile(
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Observer(
                        builder: (_) {
                          return DNText(
                            title: "${getPercent(store.tasks)}% done",
                          );
                        },
                      ),
                    ),
                    subtitle: const Align(
                      alignment: Alignment.centerRight,
                      child: DNText(
                        title: "Completed Task",
                        fontSize: 15,
                        opacity: .5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

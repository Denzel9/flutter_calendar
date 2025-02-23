import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/animate/slide.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/image.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class InfoSliver extends StatelessWidget {
  const InfoSliver({super.key});

  int getPercent(List<TaskModel> tasks) {
    if (tasks.isNotEmpty) {
      final completedTask = tasks.where((task) => task.done).length;
      return (completedTask * 100 / tasks.length).ceil();
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();

    return SliverAppBar(
      backgroundColor: Theme.of(context).primaryColorDark,
      surfaceTintColor: Colors.white,
      elevation: 0,
      pinned: true,
      toolbarHeight: 0,
      expandedHeight: 350,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
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
                          if (store.user.avatar?.isNotEmpty ?? false) {
                            return ClipOval(
                              child: DNImage(
                                url: store.user.avatar ?? '',
                                width: 40,
                                height: 40,
                              ),
                            );
                          } else {
                            return CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: const Icon(Icons.person),
                            );
                          }
                        },
                      ),
                    ),
                    DNIconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      onClick: () =>
                          Navigator.pushNamed(context, routesList.search),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlideAnimation(
                      widget: DNText(
                        title: 'Good',
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SlideAnimation(
                      widget: DNText(
                        title: getDayTitle(),
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      begin: const Offset(-1, 0),
                    )
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
                    width: 170,
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
      ),
    );
  }
}

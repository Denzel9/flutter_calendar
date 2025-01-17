import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/ui/views/user/store/user.dart';
import 'package:calendar_flutter/ui/views/user/ui/about.dart';
import 'package:calendar_flutter/ui/views/user/ui/content.dart';
import 'package:calendar_flutter/ui/views/user/ui/image_sliver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_flutter/models/user.dart';

class UserPage extends StatefulWidget {
  final User? user;

  const UserPage({super.key, this.user});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserServiceImpl userService = UserServiceImpl();
  final TaskServiceImpl taskService = TaskServiceImpl();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => UserStoreLocal(),
      builder: (context, _) {
        final UserStoreLocal userStoreLocal = context.watch<UserStoreLocal>();
        if (widget.user != null) {
          userStoreLocal.user = widget.user;
        }
        final isGuest = userStoreLocal.user?.docId != null;

        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorDark,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              ImageSliver(isGuest: isGuest),
            ],
            body: Padding(
              padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [Content(isGuest: isGuest), About(isGuest: isGuest)],
              ),
            ),
          ),
        );
      },
    );
  }
}

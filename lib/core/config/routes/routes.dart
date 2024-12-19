import 'package:calendar_flutter/ui/views/auth.dart';
import 'package:calendar_flutter/ui/views/home/home.dart';
import 'package:calendar_flutter/ui/views/notification/notification.dart';
import 'package:calendar_flutter/ui/views/task_views/task_view_page.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:calendar_flutter/ui/views/user_search_page.dart';
import 'package:flutter/material.dart';

class Routes {
  final auth = '/';
  final home = '/home';
  final user = '/user';
  final tasks = '/tasks';
  final search = '/userSearch';
  final notification = '/notification';
}

final routesList = Routes();

Map<String, Widget Function(BuildContext)> routes = {
  routesList.auth: (context) => const AuthPage(),
  routesList.home: (context) => const HomePage(),
  routesList.user: (context) => const UserPage(),
  routesList.tasks: (context) => const TaskViewPage(),
  routesList.search: (context) => const UserSearchPage(),
  routesList.notification: (context) => const NotificationPage(),
};

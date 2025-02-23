import 'package:calendar_flutter/ui/views/auth/auth.dart';
import 'package:calendar_flutter/ui/views/create/create.dart';
import 'package:calendar_flutter/ui/views/home/home.dart';
import 'package:calendar_flutter/ui/views/splash/splash.dart';
import 'package:calendar_flutter/ui/views/viewing/viewing.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:calendar_flutter/ui/views/search/search.dart';
import 'package:flutter/material.dart';

class Routes {
  final splash = '/';
  final auth = '/auth';
  final home = '/home';
  final user = '/user';
  final tasks = '/tasks';
  final search = '/userSearch';
  final notification = '/notification';
  final create = '/create';
}

final routesList = Routes();

Map<String, Widget Function(BuildContext)> routes = {
  routesList.splash: (context) => const SplashPage(),
  routesList.auth: (context) => const AuthPage(),
  routesList.home: (context) => const HomePage(),
  routesList.user: (context) => const UserPage(),
  routesList.tasks: (context) => const ViewingPage(),
  routesList.search: (context) => const SearchPage(),
  routesList.create: (context) => const CreatePage(),
};

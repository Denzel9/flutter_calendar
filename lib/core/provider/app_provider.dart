import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppProvider extends StatelessWidget {
  final Widget child;
  const AppProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Provider(
        create: (context) => AppStore(firestore),
        child: child,
      );
}

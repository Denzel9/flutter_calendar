import 'package:calendar_flutter/store/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppProvider extends StatefulWidget {
  final Widget child;
  const AppProvider({super.key, required this.child});

  @override
  State<AppProvider> createState() => _AppProviderState();
}

class _AppProviderState extends State<AppProvider> {
  late AppStore store;

  @override
  void initState() {
    store = AppStore();
    store.initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => store,
      child: widget.child,
    );
  }
}

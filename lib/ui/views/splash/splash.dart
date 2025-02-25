import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void _checkId(AppStore store) {
    Future.delayed(const Duration(seconds: 2), () async {
      final id = await localStorage.getItem('id');

      if (id.isNotEmpty) {
        await store.setUser(id);

        if (mounted) {
          setState(() {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return HomePage(id: id);
            }));
          });
        }
      } else {
        if (mounted) {
          setState(() {
            Navigator.pushReplacementNamed(context, routesList.auth);
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() async {
    final store = context.read<AppStore>();
    _checkId(store);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        body: const Center(
          child: DNText(
            title: 'DNTask',
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
            fontSize: 40,
          ),
        ),
      );
}

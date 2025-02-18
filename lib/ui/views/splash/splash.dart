import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() async {
    final store = context.read<AppStore>();

    Future.delayed(const Duration(seconds: 2), () async {
      await localStorage.getItem('id').then((id) {
        if (id.isNotEmpty) {
          store.setUser(id).then((_) {
            if (mounted) {
              Navigator.pushReplacementNamed(context, routesList.home);
            }
          });
        } else {
          if (mounted) {
            Navigator.pushReplacementNamed(context, routesList.auth);
          }
        }
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}

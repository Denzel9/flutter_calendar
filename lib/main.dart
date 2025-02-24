import 'package:calendar_flutter/core/config/firebase/firebase_options.dart';
import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/core/provider/app_provider.dart';
import 'package:calendar_flutter/core/ui/theme/theme_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => AppProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          routes: routes,
        ),
      );
}

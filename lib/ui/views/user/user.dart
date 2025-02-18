import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/user/store/user.dart';
import 'package:calendar_flutter/ui/views/user/ui/about.dart';
import 'package:calendar_flutter/ui/views/user/ui/content.dart';
import 'package:calendar_flutter/ui/views/user/ui/image_sliver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  final String? userId;

  const UserPage({super.key, this.userId});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserStoreLocal userStoreLocal = UserStoreLocal();

  @override
  void initState() {
    if (widget.userId != null) {
      userStoreLocal.getUser(widget.userId as String);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();

    return Provider(
      create: (context) => userStoreLocal,
      builder: (context, _) {
        return Observer(builder: (_) {
          final UserModel currentUser =
              userStoreLocal.isGuest ? userStoreLocal.user : store.user;
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorDark,
            body: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                ImageSliver(
                    userId: currentUser.docId ?? '', image: currentUser.avatar)
              ],
              body: Padding(
                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Content(user: currentUser),
                    About(user: currentUser)
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/main/store.dart';
import 'package:calendar_flutter/ui/views/user/store/user.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    final UserServiceImpl userService = UserServiceImpl();
    final AppStore store = context.watch<AppStore>();
    final UserStoreLocal userStoreLocal = context.watch<UserStoreLocal>();

    return Observer(
      builder: (_) {
        final currentUser =
            userStoreLocal.isGuest ? userStoreLocal.user : store.user;

        return (userStoreLocal.user?.about?.isNotEmpty ?? true)
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: DNEditableField(
                  title: currentUser?.about ?? '',
                  isEdit: userStoreLocal.isEdit,
                  editField: 'about',
                  docId: currentUser?.docId ?? '',
                  updateField: (
                    String id,
                    String field,
                    String data,
                  ) {
                    return userService.updateField(id, field, data).then(
                      ((res) {
                        setState(() {
                          store.user.about = data;
                        });
                      }),
                    );
                  },
                ),
              )
            : const SizedBox();
      },
    );
  }
}

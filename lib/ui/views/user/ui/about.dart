import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/user/store/user.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class About extends StatefulWidget {
  final UserModel user;
  const About({super.key, required this.user});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final UserStoreLocal userStoreLocal = context.watch<UserStoreLocal>();

    return Observer(
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: DNEditableField(
          title: widget.user.about ?? '',
          isEdit: userStoreLocal.isEdit,
          editField: 'about',
          docId: widget.user.docId ?? '',
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
      ),
    );
  }
}

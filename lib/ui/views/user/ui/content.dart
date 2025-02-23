import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/animate/slide.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/store/user.dart';
import 'package:calendar_flutter/ui/views/user/ui/communication.dart';
import 'package:calendar_flutter/ui/views/user/ui/statistic.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:calendar_flutter/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

Future<void> updateField(
  String id,
  String field,
  String data,
) async {
  await userService.updateField(id, field, data);
}

class Content extends StatefulWidget {
  final UserModel user;
  const Content({super.key, required this.user});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    final UserStoreLocal userStoreLocal = context.watch<UserStoreLocal>();
    final AppStore store = context.watch<AppStore>();

    return Observer(
      builder: (_) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlideAnimation(
                      begin: const Offset(-1, 0),
                      widget: DNEditableField(
                        title: toUpperCase(widget.user.name),
                        isEdit: userStoreLocal.isEdit,
                        editField: 'name',
                        docId: widget.user.docId ?? '',
                        maxFontSize: 40,
                        minFontSize: 30,
                        withTitle: false,
                        updateField: updateField,
                      ),
                    ),
                    SlideAnimation(
                      begin: const Offset(-1, 0),
                      delay: const Duration(milliseconds: 200),
                      widget: DNEditableField(
                        title: toUpperCase(widget.user.lastName),
                        isEdit: userStoreLocal.isEdit,
                        editField: 'lastName',
                        docId: widget.user.docId ?? '',
                        maxFontSize: 40,
                        minFontSize: 30,
                        withTitle: false,
                        updateField: updateField,
                      ),
                    ),
                  ],
                ),
                if (userStoreLocal.isGuest)
                  GestureDetector(
                    onTap: () async {
                      if (store.user.following.contains(widget.user.docId)) {
                        Future.wait([
                          userService.setUnFollowers(
                            store.user.docId ?? '',
                            userStoreLocal.user.docId ?? '',
                          ),
                          userService.setUnFollowing(
                            store.user.docId ?? '',
                            userStoreLocal.user.docId ?? '',
                          )
                        ]);
                      } else {
                        Future.wait([
                          userService.setFollowers(
                            store.user.docId ?? '',
                            userStoreLocal.user.docId ?? '',
                          ),
                          userService.setFollowing(
                            store.user.docId ?? '',
                            userStoreLocal.user.docId ?? '',
                          )
                        ]);
                      }
                    },
                    child: DNText(
                      title: store.user.following.contains(widget.user.docId)
                          ? "Unfollow"
                          : 'Follow',
                      height: 3,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                if (!userStoreLocal.isGuest)
                  DNIconButton(
                    icon: Icon(userStoreLocal.isEdit ? Icons.done : Icons.edit),
                    onClick: () => setState(
                      () => userStoreLocal.isEdit = !userStoreLocal.isEdit,
                    ),
                  ),
              ],
            ),
            Communication(
              userId: widget.user.docId ?? '',
              followersCount: widget.user.followers.length,
              followingCount: widget.user.following.length,
            ),
            const Divider(
              color: Colors.white60,
            ),
            if (!userStoreLocal.isGuest) ...[
              const SizedBox(height: 10),
              const Statistic()
            ]
          ],
        );
      },
    );
  }
}

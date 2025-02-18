import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/animate/slide.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/store/user.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:calendar_flutter/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Content extends StatefulWidget {
  final UserModel user;
  const Content({super.key, required this.user});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final TaskServiceImpl taskService = TaskServiceImpl(firestore);
  final UserServiceImpl userService = UserServiceImpl(firestore);

  Future<void> updateField(
    String id,
    String field,
    String data,
  ) async {
    await userService.updateField(id, field, data);
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final UserStoreLocal userStoreLocal = context.watch<UserStoreLocal>();

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      splashColor: Colors.transparent,
                      onTap: () => _showFollowBottomSheet(
                        context: context,
                        isFollowers: true,
                        usersId: widget.user.docId ?? '',
                      ).then((_) => setState(() {})),
                      contentPadding: EdgeInsets.zero,
                      title: const DNText(
                        title: 'Followers',
                        opacity: .5,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: DNText(
                          title: widget.user.followers.length.toString(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      splashColor: Colors.transparent,
                      onTap: () => _showFollowBottomSheet(
                        context: context,
                        isFollowers: false,
                        usersId: widget.user.docId ?? '',
                      ).then((_) => setState(() {})),
                      contentPadding: EdgeInsets.zero,
                      title: const DNText(
                        title: 'Following',
                        opacity: .5,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: DNText(
                          title: widget.user.following.length.toString(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future:
                          taskService.getTasksCount(widget.user.docId ?? ''),
                      builder: (context, snap) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const DNText(
                            title: 'Tasks',
                            opacity: .5,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: DNText(
                              title: snap.data.toString(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.white60,
            )
          ],
        );
      },
    );
  }
}

Future<dynamic> _showFollowBottomSheet({
  required BuildContext context,
  required bool isFollowers,
  required String usersId,
}) {
  final UserServiceImpl userService = UserServiceImpl(firestore);
  return showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 35, 35, 35),
    context: context,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DNText(title: isFollowers ? 'Followers' : 'Following'),
            StreamBuilder(
              stream: isFollowers
                  ? userService.getFollowers(usersId)
                  : userService.getFollowings(usersId),
              builder: (context, snap) {
                if (snap.data?.docs.isNotEmpty ?? false) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snap.data?.docs.length,
                      itemBuilder: (context, index) {
                        final UserModel user = UserModel.fromJsonWithId(
                            snap.data?.docs[index].data(),
                            snap.data?.docs[index].id ?? '');

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserPage(userId: user.docId);
                              },
                            ),
                          ),
                          leading: FutureBuilder(
                            future: userService.getAvatar(user.docId ?? ''),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data ?? '',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else if (!snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: 20,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                          title: DNText(title: user.name),
                          subtitle: DNText(title: user.lastName, opacity: .5),
                          trailing: const Icon(
                            Icons.north_east,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: DNText(
                        title: 'Empty',
                        color: Colors.white,
                        fontSize: 30,
                        opacity: .5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

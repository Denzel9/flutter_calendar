import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
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
  final bool isGuest;
  const Content({super.key, required this.isGuest});

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  final TextEditingController controller = TextEditingController();
  final TaskServiceImpl taskService = TaskServiceImpl();
  final UserServiceImpl userService = UserServiceImpl();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    final UserStoreLocal userStoreLocal = context.watch<UserStoreLocal>();

    return Observer(
      builder: (_) {
        final currentUser = widget.isGuest ? userStoreLocal.user : store.user;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DNEditableField(
                      title: toUpperCase(currentUser?.name ?? ''),
                      isEdit: userStoreLocal.isEdit,
                      editField: 'name',
                      docId: currentUser?.docId ?? '',
                      maxFontSize: 40,
                      minFontSize: 30,
                      withTitle: false,
                      updateField: (
                        String id,
                        String field,
                        String data,
                      ) {
                        return userService
                            .updateField(id, field, data)
                            .then(((res) {
                          setState(() {
                            store.user?.name = data;
                          });
                        }));
                      },
                    ),
                    DNEditableField(
                      title: toUpperCase(currentUser?.lastName ?? ''),
                      isEdit: userStoreLocal.isEdit,
                      editField: 'lastName',
                      docId: currentUser?.docId ?? '',
                      maxFontSize: 40,
                      minFontSize: 30,
                      withTitle: false,
                      updateField: (
                        String id,
                        String field,
                        String data,
                      ) {
                        return userService
                            .updateField(id, field, data)
                            .then(((res) {
                          setState(() {
                            store.user?.lastName = data;
                          });
                        }));
                      },
                    ),
                  ],
                ),
                if (widget.isGuest)
                  GestureDetector(
                    onTap: () {
                      userService.setFollow(
                          store.user?.docId ?? '',
                          userStoreLocal.user?.docId ?? '',
                          store.user?.following ?? []);
                      // .then(
                      //   (isAdd) => setState(() {
                      //     isAdd
                      //         ? userStoreLocal.user?.followers
                      //             .add(store.user?.docId)
                      //         : userStoreLocal.user?.followers
                      //             .remove(store.user?.docId);
                      //     userService.isLoading = false;
                      //   }),
                      // );
                    },
                    child: Text(
                      store.user?.following.contains(currentUser?.docId) ??
                              false
                          ? "Unfollow"
                          : 'Follow',
                      style: const TextStyle(
                          color: Colors.amberAccent, fontSize: 20, height: 3),
                    ),
                  ),
                if (!widget.isGuest)
                  GestureDetector(
                    onTap: () => setState(
                        () => userStoreLocal.isEdit = !userStoreLocal.isEdit),
                    child: DNIconButton(
                      icon:
                          Icon(userStoreLocal.isEdit ? Icons.done : Icons.edit),
                      onClick: () => setState(
                        () => userStoreLocal.isEdit = !userStoreLocal.isEdit,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    splashColor: Colors.transparent,
                    onTap: () {
                      _showFollowBottomSheet(
                        context,
                        true,
                        store.user?.followers ?? [],
                      ).then((_) => setState(() {}));
                    },
                    contentPadding: EdgeInsets.zero,
                    title: const DNText(
                      title: 'Followers',
                      opacity: .5,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: DNText(
                        title: currentUser?.followers.length.toString() ?? '0',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    splashColor: Colors.transparent,
                    onTap: () {
                      _showFollowBottomSheet(
                        context,
                        false,
                        store.user?.following ?? [],
                      ).then((_) => setState(() {}));
                    },
                    contentPadding: EdgeInsets.zero,
                    title: const DNText(
                      title: 'Following',
                      opacity: .5,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: DNText(
                        title: currentUser?.following.length.toString() ?? '0',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: taskService.getTasksCount(currentUser?.docId ?? ''),
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
            const Divider(
              color: Colors.white60,
            )
          ],
        );
      },
    );
  }
}

Future<dynamic> _showFollowBottomSheet(
    BuildContext context, bool isFollowers, List<dynamic> usersIds) {
  final UserServiceImpl userService = UserServiceImpl();
  return showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 35, 35, 35),
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              DNText(
                title: isFollowers ? 'Followers' : 'Following',
              ),
              FutureBuilder(
                future: userService.getUser(usersIds),
                builder: (context, snap) {
                  if (snap.hasData) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snap.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          final User user = snap.data![index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return UserPage(
                                    user: user,
                                  );
                                },
                              ),
                            ),
                            leading: FutureBuilder(
                              future: userService.getAvatar(user.docId),
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
                                  return const CircleAvatar();
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
                  } else if (!snap.hasData &&
                      snap.connectionState == ConnectionState.done) {
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
                  } else {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

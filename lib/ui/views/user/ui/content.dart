import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/store/user.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:calendar_flutter/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Content extends StatefulWidget {
  final User user;
  const Content({super.key, required this.user});

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
    final store = context.watch<AppStore>();
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
                    DNEditableField(
                      title: toUpperCase(widget.user.name),
                      isEdit: userStoreLocal.isEdit,
                      editField: 'name',
                      controller: controller,
                      taskId: widget.user.docId,
                      maxFontSize: 40,
                    ),
                    DNEditableField(
                      title: toUpperCase(widget.user.lastName),
                      isEdit: userStoreLocal.isEdit,
                      editField: 'lastName',
                      controller: controller,
                      taskId: widget.user.docId,
                      maxFontSize: 40,
                    ),
                  ],
                ),
                if (userStoreLocal.guestId.isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      await userService.setFollow(store.user?.docId ?? '',
                          userStoreLocal.guestId, store.user?.following ?? []);
                    },
                    child: Text(
                      store.user?.following.contains(userStoreLocal.guestId) ??
                              false
                          ? "Unfollow"
                          : 'Follow',
                      style: const TextStyle(
                          color: Colors.amberAccent, fontSize: 20, height: 3),
                    ),
                  ),
                if (userStoreLocal.guestId.isEmpty)
                  GestureDetector(
                    onTap: () => setState(
                        () => userStoreLocal.isEdit = !userStoreLocal.isEdit),
                    child: Text(
                      userStoreLocal.isEdit ? 'Done' : 'Edit',
                      style: const TextStyle(
                          color: Colors.amberAccent, fontSize: 20),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    onTap: () =>
                        _showFollowBottomShet(context, true, widget.user.docId),
                    contentPadding: EdgeInsets.zero,
                    title: const DNText(
                      title: 'Followers',
                      opacity: .5,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: userStoreLocal.guestId.isNotEmpty
                          ? FutureBuilder(
                              future: userService
                                  .getFollowers(userStoreLocal.guestId),
                              builder: (context, snap) {
                                return DNText(
                                  title: snap.data?.length.toString() ?? '0',
                                  fontWeight: FontWeight.bold,
                                );
                              })
                          : DNText(
                              title: store.user?.followers.length.toString() ??
                                  '0',
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    onTap: () => _showFollowBottomShet(
                        context, false, widget.user.docId),
                    contentPadding: EdgeInsets.zero,
                    title: const DNText(
                      title: 'Following',
                      opacity: .5,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: userStoreLocal.guestId.isNotEmpty
                          ? FutureBuilder(
                              future: userService
                                  .getFollowing(userStoreLocal.guestId),
                              builder: (context, snap) {
                                return DNText(
                                  title: snap.data?.length.toString() ?? "0",
                                  fontWeight: FontWeight.bold,
                                );
                              })
                          : DNText(
                              title: store.user?.following.length.toString() ??
                                  "0",
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: taskService.getTasksCount(widget.user.docId),
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
          ],
        );
      },
    );
  }
}

Future<dynamic> _showFollowBottomShet(
    BuildContext context, bool isFollowers, String userId) {
  return showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 35, 35, 35),
    context: context,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DNText(
              title: isFollowers ? 'Followers' : 'Following',
            ),
            FutureBuilder(
              future: isFollowers
                  ? userService.getFollowers(userId)
                  : userService.getFollowing(userId),
              builder: (context, snap) {
                if (snap.data?.isEmpty ?? true) {
                  return const Center(
                    child: DNText(
                      title: 'Empty',
                      color: Colors.white,
                      fontSize: 30,
                      opacity: .5,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snap.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final user = snap.data![index];
                      return GestureDetector(
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
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://microsac.es/wp-content/uploads/2019/06/8V1z7D_t20_YX6vKm.jpg',
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: DNText(title: user.name),
                          subtitle: DNText(title: user.lastName, opacity: .5),
                          trailing: isFollowers
                              ? const SizedBox()
                              : const SizedBox(
                                  width: 70,
                                  child:
                                      DNText(title: 'Unfollow', fontSize: 14),
                                ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}

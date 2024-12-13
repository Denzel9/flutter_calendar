import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/widgets/card.dart';
import 'package:calendar_flutter/ui/widgets/editable_field.dart';
import 'package:calendar_flutter/utils/format.dart';
import 'package:calendar_flutter/core/config/routes/routes.dart';

class UserPage extends StatefulWidget {
  final User? user;

  const UserPage({
    super.key,
    this.user,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final fieldController = TextEditingController();
  late UserStore _userStore;
  late UserServiceImpl _userService;
  late TaskServiceImpl _taskService;
  final ImagePicker imagePicker = ImagePicker();
  final routesList = Routes();
  late User user;
  bool isEdit = false;
  String guestId = '';
  File? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);
    _userService = Provider.of<UserServiceImpl>(context);
    _taskService = Provider.of<TaskServiceImpl>(context);
    setState(() {
      if (widget.user != null) {
        user = widget.user as User;
        guestId = widget.user!.docId;
      } else {
        user = _userStore.user;
      }
    });
  }

  @override
  void dispose() {
    fieldController.dispose();
    guestId = '';
    super.dispose();
  }

  Future<void> pickImage() async {
    XFile? xFileImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFileImage != null) {
      setState(() {
        image = File(xFileImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            pinned: true,
            expandedHeight: 300,
            leading: const BackButton(
              color: Colors.white,
              style: ButtonStyle(iconSize: WidgetStatePropertyAll(30)),
            ),
            actions: [
              if (isEdit)
                DNIconButton(
                  onClick: pickImage,
                  icon: const Icon(
                    Icons.image,
                    color: Colors.black,
                  ),
                ),
              if (isEdit && image != null)
                DNIconButton(
                  backgroundColor: Colors.red,
                  onClick: () => setState(() {
                    image = null;
                  }),
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
              if (isEdit && image != null)
                DNIconButton(
                  backgroundColor: Colors.green,
                  onClick: () => _userService.setAvatar(image!),
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                ),
              const SizedBox(width: 10)
            ],
            leadingWidth: 50,
            flexibleSpace: FlexibleSpaceBar(
              background: FutureBuilder(
                future: _userService.getAvatar(user.docId),
                builder: (context, snap) {
                  if (image?.path.isNotEmpty ?? false) {
                    Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                    );
                  }
                  if (snap.hasData) {
                    return Skeletonizer(
                      enabled: !snap.hasData,
                      child: CachedNetworkImage(
                        imageUrl: snap.data ?? '',
                      ),
                    );
                  } else {
                    return Skeletonizer(
                      child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    );
                  }
                },
              ),
            ),
          )
        ],
        body: Padding(
          padding:
              const EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DNEditableField(
                          title: toUpperCase(user.name),
                          isEdit: isEdit,
                          editField: 'name',
                          controller: fieldController,
                          taskId: user.docId,
                        ),
                        DNEditableField(
                          title: toUpperCase(user.lastName),
                          isEdit: isEdit,
                          editField: 'lastName',
                          controller: fieldController,
                          taskId: user.docId,
                        ),
                      ],
                    ),
                    if (guestId.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _userService.setFollow(
                            _userStore.user.docId,
                            guestId,
                          );
                          setState(() {});
                        },
                        child: Text(
                          _userStore.user.following.contains(guestId)
                              ? "Unfollow"
                              : 'Follow',
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    if (guestId.isEmpty)
                      GestureDetector(
                        onTap: () => setState(() => isEdit = !isEdit),
                        child: Text(
                          isEdit ? 'Done' : 'Edit',
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
                        onTap: () => _showFollowBottomShet(context, true),
                        contentPadding: EdgeInsets.zero,
                        title: const DNText(
                          title: 'Followers',
                          opacity: .5,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: FutureBuilder(
                              future: _userService.getFollowers(user.docId),
                              builder: (context, snap) {
                                return DNText(
                                  title: snap.data?.length.toString() ?? '0',
                                  fontWeight: FontWeight.bold,
                                );
                              }),
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListTile(
                      onTap: () => _showFollowBottomShet(context, false),
                      contentPadding: EdgeInsets.zero,
                      title: const DNText(
                        title: 'Following',
                        opacity: .5,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: FutureBuilder(
                            future: _userService.getFollowing(user.docId),
                            builder: (context, snap) {
                              return DNText(
                                title: snap.data?.length.toString() ?? "0",
                                fontWeight: FontWeight.bold,
                              );
                            }),
                      ),
                    )),
                    // Expanded(
                    //   child: FutureBuilder(
                    //     future: _taskService.getTasks(user.docId),
                    //     builder: (context, snap) {
                    //       return ListTile(
                    //         contentPadding: EdgeInsets.zero,
                    //         title: const DNText(
                    //           title: 'Tasks',
                    //           opacity: .5,
                    //         ),
                    //         subtitle: Padding(
                    //           padding: const EdgeInsets.only(top: 5.0),
                    //           child: DNText(
                    //             title: snap.data?.length.toString() ?? '0',
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),
                const AutoSizeText(
                  'In the following guide, I want to show you what to say and how to say it when talking about your job. You may be required to talk about your job at a party or a social event. But you may also have to talk about your job if you are changing from one company to another and having interviews. In any situation, if you are working you should be able to express yourself in English when talking about your job.',
                  style: TextStyle(color: Colors.white),
                  minFontSize: 18,
                  maxFontSize: 18,
                ),
                const SizedBox(height: 20),
                const DNCard(
                  title: 'following guide',
                  subtitle: 'following guide',
                  description: 'following guide',
                ),
                const DNCard(
                  title: 'following guide',
                  subtitle: 'following guide',
                  description: 'following guide',
                ),
                const DNCard(
                  title: 'following guide',
                  subtitle: 'following guide',
                  description: 'following guide',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showFollowBottomShet(
      BuildContext context, bool isFollowers) {
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
                    ? _userService.getFollowers(user.docId)
                    : _userService.getFollowing(user.docId),
                builder: (context, snap) {
                  if (snap.data?.isEmpty ?? true) {
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
                              child: Image.network(
                                  'https://microsac.es/wp-content/uploads/2019/06/8V1z7D_t20_YX6vKm.jpg',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover),
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
}

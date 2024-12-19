import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/notification/notification_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/store/user.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ImageSliver extends StatefulWidget {
  final User user;
  const ImageSliver({super.key, required this.user});

  @override
  State<ImageSliver> createState() => _ImageSliverState();
}

class _ImageSliverState extends State<ImageSliver> {
  final ImagePicker imagePicker = ImagePicker();
  final UserServiceImpl userService = UserServiceImpl();
  final NotificationServiceImpl notificationService = NotificationServiceImpl();

  Future<void> pickImage(UserStoreLocal userStoreLocal) async {
    XFile? xFileImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFileImage != null) {
      setState(() {
        userStoreLocal.image = File(xFileImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserStoreLocal userStoreLocal = context.watch<UserStoreLocal>();
    final AppStore store = context.watch<AppStore>();
    return Observer(builder: (_) {
      return SliverAppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        pinned: true,
        expandedHeight: 300,
        leading: const BackButton(
          color: Colors.white,
          style: ButtonStyle(iconSize: WidgetStatePropertyAll(30)),
        ),
        actions: [
          if (!userStoreLocal.isEdit && userStoreLocal.guestId.isEmpty ||
              store.user!.following.contains(userStoreLocal.guestId))
            DNIconButton(
              onClick: () => showSettingBottomShet(
                  context, notificationService, userStoreLocal.guestId),
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
            ),
          if (userStoreLocal.isEdit)
            DNIconButton(
              onClick: () => pickImage(userStoreLocal),
              icon: const Icon(
                Icons.image,
                color: Colors.black,
              ),
            ),
          if (userStoreLocal.isEdit && userStoreLocal.image != null)
            DNIconButton(
              backgroundColor: Colors.red,
              onClick: () => setState(() {
                userStoreLocal.image = null;
              }),
              icon: const Icon(
                Icons.clear,
                color: Colors.white,
              ),
            ),
          if (userStoreLocal.isEdit && userStoreLocal.image != null)
            DNIconButton(
              backgroundColor: Colors.green,
              onClick: () => userService.setAvatar(userStoreLocal.image!),
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
            future: userService.getAvatar(widget.user.docId),
            builder: (context, snap) {
              if (userStoreLocal.image?.path.isNotEmpty ?? false) {
                return Image.file(
                  File(userStoreLocal.image!.path),
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
      );
    });
  }
}

Future<dynamic> showSettingBottomShet(BuildContext context,
    NotificationServiceImpl notificationService, String id) {
  const bool isWaitingRequest = false;
  return showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 35, 35, 35),
    context: context,
    builder: (context) {
      final AppStore store = context.read<AppStore>();
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.center,
              child: DNText(
                title: 'Settings',
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const DNText(title: 'Request for collaboration'),
              subtitle: isWaitingRequest
                  ? const DNText(
                      title: 'User has not accepted the request yet',
                      fontSize: 12,
                    )
                  : null,
              trailing: isWaitingRequest
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ))
                  : Switch(
                      value: false,
                      onChanged: (value) {
                        value = !value;
                        notificationService.send({
                          'author':
                              '${store.user?.name} ${store.user?.lastName}',
                          'title': "title",
                          'createdAt': now.toString(),
                          'userId': id,
                          'operation': 'colaboration',
                        });
                      },
                    ),
            )
          ],
        ),
      );
    },
  );
}

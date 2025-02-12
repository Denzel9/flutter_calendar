import 'dart:io';
import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/image.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/store/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImageSliver extends StatefulWidget {
  const ImageSliver({super.key});

  @override
  State<ImageSliver> createState() => _ImageSliverState();
}

class _ImageSliverState extends State<ImageSliver> {
  final ImagePicker imagePicker = ImagePicker();
  final UserServiceImpl userService = UserServiceImpl(firestore);

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

    return Observer(
      builder: (_) {
        final currentUser =
            userStoreLocal.isGuest ? userStoreLocal.user : store.user;

        return SliverAppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).primaryColorDark,
          elevation: 0,
          pinned: true,
          expandedHeight: 300,
          leading: BackButton(
            color: Theme.of(context).primaryColor,
            style: const ButtonStyle(
              iconSize: WidgetStatePropertyAll(30),
            ),
          ),
          actions: [
            if (!userStoreLocal.isGuest && !userStoreLocal.isEdit)
              DNIconButton(
                onClick: () {
                  showModalBottomSheet(
                    backgroundColor: const Color.fromARGB(255, 35, 35, 35),
                    context: context,
                    builder: (_) {
                      return Container(
                        padding: const EdgeInsets.all(20),
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
                              onTap: () async {
                                await localStorage.deleteItem('id');
                                if (context.mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, routesList.auth);
                                }
                              },
                              title: const DNText(title: 'Change account'),
                              trailing: Icon(
                                Icons.exit_to_app,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
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
                onClick: () => setState(() => userStoreLocal.image = null),
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            if (userStoreLocal.isEdit && userStoreLocal.image != null)
              DNIconButton(
                backgroundColor: Colors.green,
                onClick: () => userService
                    .setAvatar(userStoreLocal.image!, store.user.docId ?? '')
                    .then((_) => setState(() {
                          userStoreLocal.image = null;
                        })),
                icon: const Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              ),
            const SizedBox(width: 10)
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: FutureBuilder(
              future: userService.getAvatar(currentUser?.docId ?? ''),
              builder: (context, snap) {
                if (userStoreLocal.image?.path.isNotEmpty ?? false) {
                  return Image.file(
                    File(userStoreLocal.image!.path),
                    fit: BoxFit.cover,
                  );
                }
                if (snap.hasData) {
                  return DNImage(
                    url: snap.data ?? '',
                  );
                }
                if (!snap.hasData &&
                    snap.connectionState == ConnectionState.done) {
                  return const DNImage(
                      url:
                          'https://ardexpert.ru/uploads/avatars/0/0/0/big-638dd962a81810.96619622.jpg');
                }
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  }
}

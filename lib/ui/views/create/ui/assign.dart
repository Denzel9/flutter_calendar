import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/image.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Assign extends StatefulWidget {
  const Assign({super.key});

  @override
  State<Assign> createState() => _AssignState();
}

class _AssignState extends State<Assign> {
  final UserServiceImpl userService = UserServiceImpl();

  @override
  Widget build(BuildContext context) {
    final CreateStoreLocal createStore = context.watch<CreateStoreLocal>();
    final AppStore store = context.watch<AppStore>();

    void doAssign(String id) {
      setState(() {
        if (createStore.assign.where((el) => el == id).isEmpty) {
          createStore.assign = [...createStore.assign, id];
        } else {
          createStore.assign =
              createStore.assign.where((el) => el != id).toList();
        }
      });
    }

    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DNText(
              title: 'Assign',
              opacity: .5,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: createStore.assign.length + 1,
                        itemBuilder: (context, index) {
                          if (index < createStore.assign.length) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: FutureBuilder(
                                future: userService
                                    .getAvatar(createStore.assign[index]),
                                builder: (context, snap) {
                                  if (snap.hasData) {
                                    return ClipOval(
                                      child: DNImage(
                                        url: snap.data.toString(),
                                        width: 40,
                                        height: 40,
                                      ),
                                    );
                                  }
                                  return CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: const Icon(Icons.person));
                                },
                              ),
                            );
                          } else {
                            return DNIconButton(
                              onClick: () => showModalBottomSheet(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                context: context,
                                builder: (_) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: double.infinity,
                                    child: StreamBuilder(
                                      stream: userService
                                          .getFollowers(store.user.docId ?? ''),
                                      builder: (context, snap) {
                                        if (snap.data?.docs.isNotEmpty ??
                                            false) {
                                          return ListView.builder(
                                            itemCount: snap.data?.docs.length,
                                            itemBuilder: (context, index) {
                                              final UserModel user =
                                                  UserModel.fromJsonWithId(
                                                      snap.data?.docs[index]
                                                          .data(),
                                                      snap.data?.docs[index]
                                                              .id ??
                                                          '');

                                              return ListTile(
                                                title: DNText(
                                                  title: user.name,
                                                ),
                                                subtitle: DNText(
                                                  title: user.lastName,
                                                ),
                                                leading: FutureBuilder(
                                                    future:
                                                        userService.getAvatar(
                                                            user.docId ?? ''),
                                                    builder: (context, snap) {
                                                      if (snap.hasData) {
                                                        return ClipOval(
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                snap.data ?? '',
                                                            width: 40,
                                                            height: 40,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                      } else if (!snap
                                                              .hasData &&
                                                          snap.connectionState ==
                                                              ConnectionState
                                                                  .done) {
                                                        return const CircleAvatar();
                                                      } else {
                                                        return const CircularProgressIndicator();
                                                      }
                                                    }),
                                                trailing:
                                                    Observer(builder: (_) {
                                                  return DNIconButton(
                                                    onClick: () => doAssign(
                                                        user.docId ?? ''),
                                                    icon: createStore.assign
                                                            .contains(
                                                                user.docId)
                                                        ? const Icon(Icons.done)
                                                        : const Icon(Icons.add),
                                                  );
                                                }),
                                              );
                                            },
                                          );
                                        } else {
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
                                      },
                                    ),
                                  );
                                },
                              ),
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

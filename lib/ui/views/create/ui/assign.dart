import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
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
  final UserServiceImpl userService = UserServiceImpl(firestore);

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
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: AlignmentDirectional.center,
                        children: [
                          for (var i = 0; i < createStore.assign.length; i++)
                            Positioned(
                              left: i * 30,
                              child: FutureBuilder(
                                future: userService
                                    .getAvatar(createStore.assign[i]),
                                builder: (context, snap) {
                                  if (snap.data != null) {
                                    return ClipOval(
                                      child: Image.network(
                                        snap.data.toString(),
                                        fit: BoxFit.cover,
                                        width: 40,
                                        height: 40,
                                      ),
                                    );
                                  }
                                  return Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: Icon(Icons.person,
                                        color: Theme.of(context).primaryColor),
                                  );
                                },
                              ),
                            ),
                          Positioned(
                            left: createStore.assign.length * 30,
                            child: DNIconButton(
                              onClick: () => showModalBottomSheet(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                context: context,
                                builder: (context) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    width: double.infinity,
                                    child: StreamBuilder(
                                      stream: userService
                                          .getFollowers(store.user.docId ?? ''),
                                      builder: (context, snap) {
                                        if (snap.hasData) {
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
                                                trailing: Observer(
                                                  builder: (_) {
                                                    return DNIconButton(
                                                      onClick: () => doAssign(
                                                          user.docId ?? ''),
                                                      icon: createStore.assign
                                                              .contains(
                                                                  user.docId)
                                                          ? const Icon(
                                                              Icons.done)
                                                          : const Icon(
                                                              Icons.add),
                                                    );
                                                  },
                                                ),
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
                            ),
                          )
                        ],
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

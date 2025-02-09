import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/main/store.dart';
import 'package:calendar_flutter/ui/components/button.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/image.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Assign extends StatefulWidget {
  final String docId;
  final List<dynamic> assignList;
  const Assign({super.key, required this.assignList, required this.docId});

  @override
  State<Assign> createState() => _AssignState();
}

class _AssignState extends State<Assign> {
  final UserServiceImpl userService = UserServiceImpl(firestore);
  final TaskServiceImpl taskService = TaskServiceImpl(firestore);

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();

    return GestureDetector(
      onTap: () => showModalBottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setStateModal) => Container(
              margin: const EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  StreamBuilder(
                    stream: userService.getFollowers(store.user.docId ?? ''),
                    builder: (context, snap) {
                      if (snap.data?.docs.isNotEmpty ?? false) {
                        return ListView.builder(
                          itemCount: snap.data?.docs.length,
                          itemBuilder: (context, index) {
                            final UserModel user = UserModel.fromJsonWithId(
                                snap.data?.docs[index].data(),
                                snap.data?.docs[index].id ?? '');

                            return ListTile(
                              title: DNText(title: user.name),
                              subtitle: DNText(title: user.lastName),
                              leading: FutureBuilder(
                                future: userService.getAvatar(user.docId ?? ''),
                                builder: (context, snap) {
                                  if (snap.hasData) {
                                    return ClipOval(
                                      child: DNImage(
                                        url: snap.data!,
                                        width: 40,
                                        height: 40,
                                      ),
                                    );
                                  } else {
                                    return CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: const Icon(Icons.person),
                                    );
                                  }
                                },
                              ),
                              trailing: DNIconButton(
                                onClick: () {
                                  if (widget.assignList
                                      .where((el) => el == user.docId)
                                      .isEmpty) {
                                    setStateModal(() {
                                      widget.assignList.add(user.docId);
                                    });
                                  } else {
                                    setStateModal(() {
                                      widget.assignList.remove(user.docId);
                                    });
                                  }
                                },
                                icon: widget.assignList.contains(user.docId)
                                    ? const Icon(Icons.delete)
                                    : const Icon(Icons.add),
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
                  if (widget.assignList.isNotEmpty)
                    Positioned(
                      right: 30,
                      bottom: 40,
                      child: DNButton(
                        title: 'Save',
                        onClick: () {
                          taskService.editAssign(
                            widget.docId,
                            widget.assignList,
                          );
                          Navigator.pop(context);
                        },
                        isPrimary: true,
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
      child: widget.assignList.isEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 10),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: const Icon(Icons.add),
            )
          : SizedBox(
              width: 200,
              height: 40,
              child: Stack(
                alignment: Alignment.centerRight,
                children: List.generate(
                  widget.assignList.length,
                  (index) {
                    return Positioned(
                      right: index * 25,
                      child: FutureBuilder(
                        future: userService.getAvatar(widget.assignList[index]),
                        builder: (context, snap) {
                          if (snap.hasData) {
                            return ClipOval(
                              child: DNImage(
                                url: snap.data!,
                                width: 40,
                                height: 40,
                              ),
                            );
                          } else {
                            return CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: const Icon(Icons.person));
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}

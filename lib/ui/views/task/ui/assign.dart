import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/store/store.dart';
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
  List<dynamic> initAssignList = [];

  @override
  void initState() {
    initAssignList = [...widget.assignList];
    super.initState();
  }

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
                                  if (initAssignList
                                      .where((el) => el == user.docId)
                                      .isEmpty) {
                                    setStateModal(() {
                                      initAssignList.add(user.docId);
                                    });
                                  } else {
                                    setStateModal(() {
                                      initAssignList.remove(user.docId);
                                    });
                                  }
                                },
                                icon: initAssignList.contains(user.docId)
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
                  if (widget.assignList.length != initAssignList.length)
                    Positioned(
                      right: 30,
                      bottom: 40,
                      child: DNButton(
                        title: 'Save',
                        onClick: () {
                          taskService
                              .editAssign(
                            widget.docId,
                            initAssignList,
                          )
                              .then((_) {
                            taskService.updateField(
                                widget.docId,
                                'isCollaborated',
                                initAssignList.isEmpty ? false : true);
                          });
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
      ).then(
        (_) => setState(() {
          initAssignList = [...widget.assignList];
        }),
      ),
      child: widget.assignList.isEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 10),
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
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
                              child: const Icon(Icons.person),
                            );
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

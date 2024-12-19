import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/create/store/create.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Assign extends StatefulWidget {
  const Assign({super.key});

  @override
  State<Assign> createState() => _AssignState();
}

class _AssignState extends State<Assign> {
  final UserServiceImpl userService = UserServiceImpl();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final List<dynamic> followers = AppStore().user?.followers ?? [];
    context.read<CreateStoreLocal>().assign = [...followers, 'add'];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final CreateStoreLocal createStore = CreateStoreLocal();
    final AppStore store = AppStore();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const DNText(
              title: 'Assign',
              opacity: .5,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            if (createStore.assign.isNotEmpty)
              GestureDetector(
                child: const DNText(
                  title: 'Edit',
                  opacity: .5,
                  fontWeight: FontWeight.bold,
                ),
                onTap: () {},
              )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                            future:
                                userService.getAvatar(createStore.assign[i]),
                            builder: (context, snap) {
                              if (snap.hasData) {
                                return ClipOval(
                                  child: Image.network(
                                    snap.data.toString(),
                                    fit: BoxFit.cover,
                                    width: 40,
                                    height: 40,
                                  ),
                                );
                              }
                              return const ClipOval(
                                child: ColoredBox(color: Colors.red),
                              );
                            },
                          ),
                        ),
                      Positioned(
                        left: createStore.assign.length * 30,
                        child: DNIconButton(
                          onClick: () => showAssign(context,
                              store.user?.docId ?? '', createStore.assign),
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
  }
}

void showAssign(BuildContext context, String id, List<String> assignList) {
  showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 35, 35, 35),
    context: context,
    builder: (context) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: userService.getFollowers(id),
          builder: (context, snap) {
            return ListView.builder(
              itemCount: snap.data?.length,
              itemBuilder: (context, index) {
                final user = snap.data?[index];
                return ListTile(
                  title: DNText(
                    title: user?.name ?? '',
                  ),
                  subtitle: DNText(
                    title: user?.lastName ?? '',
                  ),
                  leading: ClipOval(
                    child: FutureBuilder(
                      future: userService.getAvatar('user?.docId'),
                      builder: (context, snap) {
                        return ClipOval(
                          child: Image.network(
                            snap.data!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  trailing: DNIconButton(
                    onClick: () {
                      if (assignList.where((el) => el == id).isEmpty) {
                        assignList = [...assignList, id];
                      }
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add),
                  ),
                );
              },
            );
          },
        ),
      );
    },
  );
}

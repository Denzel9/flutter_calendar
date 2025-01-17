import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:calendar_flutter/utils/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchStatePage();
}

class _UserSearchStatePage extends State<UserSearchPage> {
  final UserServiceImpl userService = UserServiceImpl();
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userId = context.read<AppStore>().user?.docId ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).primaryColorDark,
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: const BackButton(color: Colors.amberAccent),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: DNInput(
                    title: 'Search users',
                    controller: controller,
                    autoFocus: true,
                    onClick: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              stream: userService.getAllUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount:
                        searchUser(snapshot.data?.docs, controller)?.length,
                    itemBuilder: (context, index) {
                      final user =
                          searchUser(snapshot.data?.docs, controller)?[index];
                      if (user != null && user.docId != userId) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserPage(user: user);
                              },
                            ),
                          ),
                          child: ListTile(
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
                                }),
                            title:
                                DNText(title: '${user.name} ${user.lastName}'),
                            subtitle: DNText(
                              title: user.email,
                              fontSize: 15,
                              opacity: .5,
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

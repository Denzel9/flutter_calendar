import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/image.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:calendar_flutter/utils/format.dart';
import 'package:calendar_flutter/utils/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _UserSearchStatePage();
}

class _UserSearchStatePage extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser;

  @override
  void initState() {
    getAllUser = userService.getAllUser();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String userId = context.read<AppStore>().user.docId ?? '';

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
            padding: const EdgeInsets.all(10),
            child: DNInput(
              title: 'Search users',
              controller: controller,
              autoFocus: true,
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: getAllUser,
              builder: (context, snapshot) {
                final users = searchUser(snapshot.data?.docs, controller);
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: users?.length,
                    itemBuilder: (context, index) {
                      final user = users?[index];
                      if (user != null && user.docId != userId) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserPage(userId: user.docId),
                            ),
                          ),
                          child: ListTile(
                            leading: FutureBuilder(
                              future: userService.getAvatar(user.docId ?? ''),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ClipOval(
                                    child: DNImage(
                                      url: snapshot.data ?? '',
                                      width: 40,
                                      height: 40,
                                    ),
                                  );
                                } else if (!snapshot.hasData &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  return CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      radius: 20,
                                      child: const Icon(Icons.person));
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                            title: DNText(
                                title:
                                    '${toUpperCase(user.name)} ${toUpperCase(user.lastName)}'),
                            subtitle: DNText(
                              title: user.email,
                              fontSize: 15,
                              opacity: .5,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
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

import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user.dart';
import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:flutter/material.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchStatePage();
}

class _UserSearchStatePage extends State<UserSearchPage> {
  final controller = TextEditingController();
  late Future<List<User>> users;
  final routesList = Routes();

  @override
  void initState() {
    super.initState();
    // users = userService.getAllUser(controller.text.trim());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const BackButton(
          color: Colors.amberAccent,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: DNInput(
                    title: 'Search',
                    controller: controller,
                  ),
                ),
                DNIconButton(
                  icon: const Icon(Icons.search),
                  onClick: () {
                    setState(() {
                      // users = userService.getAllUser(controller.text.trim());
                    });
                  },
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: users,
              builder: (context, snapshot) => ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  if (snapshot.hasData) {
                    final user = snapshot.data?[index];
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
                        title: DNText(
                          title: user?.email ?? '',
                        ),
                        subtitle: DNText(
                          title: user?.docId ?? '',
                          fontSize: 14,
                          opacity: .5,
                        ),
                        leading: const CircleAvatar(),
                      ),
                    );
                  } else {
                    return Text('${snapshot.error}');
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

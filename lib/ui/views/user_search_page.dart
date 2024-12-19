import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/ui/components/input.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:calendar_flutter/core/config/routes/routes.dart';
import 'package:flutter/material.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({super.key});

  @override
  State<UserSearchPage> createState() => _UserSearchStatePage();
}

class _UserSearchStatePage extends State<UserSearchPage> {
  final UserServiceImpl userService = UserServiceImpl();
  final TextEditingController controller = TextEditingController();
  Future<List<User>>? users;
  final routesList = Routes();
  final FocusNode focusNode = FocusNode();

  void getUsers() {
    setState(() {
      users = userService.getAllUser(controller.text.trim());
    });
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    controller.addListener(() {
      getUsers();
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    title: 'Search',
                    controller: controller,
                    autoFocus: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: users,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (controller.text.length > 2) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
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
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

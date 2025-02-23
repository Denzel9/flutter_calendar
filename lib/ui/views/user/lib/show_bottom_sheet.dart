import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:calendar_flutter/ui/views/user/user.dart';
import 'package:flutter/material.dart';

Future<dynamic> showFollowBottomSheet({
  required BuildContext context,
  required bool isFollowers,
  required String usersId,
}) {
  return showModalBottomSheet(
    backgroundColor: const Color.fromARGB(255, 35, 35, 35),
    context: context,
    builder: (_) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DNText(title: isFollowers ? 'Followers' : 'Following'),
            StreamBuilder(
              stream: isFollowers
                  ? userService.getFollowers(usersId)
                  : userService.getFollowings(usersId),
              builder: (context, snap) {
                if (snap.data?.docs.isNotEmpty ?? false) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snap.data?.docs.length,
                      itemBuilder: (context, index) {
                        final UserModel user = UserModel.fromJsonWithId(
                            snap.data?.docs[index].data(),
                            snap.data?.docs[index].id ?? '');

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserPage(userId: user.docId);
                              },
                            ),
                          ),
                          leading: FutureBuilder(
                            future: userService.getAvatar(user.docId ?? ''),
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
                                return CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  radius: 20,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                          title: DNText(title: user.name),
                          subtitle: DNText(title: user.lastName, opacity: .5),
                          trailing: const Icon(
                            Icons.north_east,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: DNText(
                        title: 'Empty',
                        color: Colors.white,
                        fontSize: 30,
                        opacity: .5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/ui/components/image.dart';
import 'package:flutter/material.dart';

final UserServiceImpl userService = UserServiceImpl(firestore);

class DNAvatar extends StatelessWidget {
  final String url;
  const DNAvatar({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userService.getAvatar(url),
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
    );
  }
}

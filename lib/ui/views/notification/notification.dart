import 'package:calendar_flutter/models/notification.dart';
import 'package:calendar_flutter/service/notification/notification_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/views/notification/ui/colaboration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationServiceImpl notificationService =
        NotificationServiceImpl();
    final AppStore store = context.watch<AppStore>();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        leading: BackButton(
          color: Theme.of(context).primaryColor,
        ),
      ),
      body: Observer(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: StreamBuilder(
              stream: notificationService.get(store.user?.docId ?? ''),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    if (snapshot.hasData) {
                      final notification = NotificationModel.fromJsonWithId(
                          snapshot.data?.docs[index].data(),
                          snapshot.data!.docs[index].id);
                      if (notification.operation == 'colaboration') {
                        return Colaboration(
                          notification: notification,
                        );
                      } else {
                        return const SizedBox();
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

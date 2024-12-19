import 'package:calendar_flutter/models/notification.dart';
import 'package:calendar_flutter/service/notification/notification_service_impl.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/ui/components/icon_button.dart';
import 'package:calendar_flutter/ui/components/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Colaboration extends StatefulWidget {
  final NotificationModel notification;
  const Colaboration({super.key, required this.notification});

  @override
  State<Colaboration> createState() => _ColaborationState();
}

class _ColaborationState extends State<Colaboration> {
  final NotificationServiceImpl notificationService = NotificationServiceImpl();

  @override
  Widget build(BuildContext context) {
    final AppStore store = context.watch<AppStore>();
    bool swithValue =
        store.user?.colaborated.contains(widget.notification.guestId) ?? false;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: ListTile(
        title: DNText(
          title: 'Request for collaboration',
          color: swithValue ? Colors.green : Colors.white,
        ),
        subtitle: DNText(
          title: widget.notification.author,
          fontSize: 12,
        ),
        trailing: widget.notification.isAccepted
            ? DNIconButton(
                color: Colors.red.shade400,
                backgroundColor: Colors.transparent,
                icon: const Icon(Icons.delete),
                onClick: () =>
                    notificationService.delete(widget.notification.docId),
              )
            : Switch(
                value: swithValue,
                onChanged: (value) {
                  Future.wait([
                    notificationService.accept(
                      store.user?.docId ?? '',
                      widget.notification.guestId,
                    ),
                    notificationService.update(widget.notification.docId, true)
                  ]);
                },
              ),
      ),
    );
  }
}

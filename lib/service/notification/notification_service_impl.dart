import 'package:calendar_flutter/service/notification/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

class NotificationServiceImpl implements NotificationService {
  @override
  Future<void> send(Map<String, dynamic> notification) async {
    db.collection("notification").add(notification);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> get(String id) {
    return db
        .collection("notification")
        .where('userId', isEqualTo: id)
        .snapshots();
  }

  @override
  Future<void> accept(String userId, String guestId) async {
    db.collection("users").doc(userId).update({
      "colaborated": FieldValue.arrayUnion([guestId])
    });
  }

  @override
  Future<void> delete(String id) async {
    db.collection("notification").doc(id).delete();
  }

  @override
  Future<void> update(String id, bool isAccepted) async {
    db.collection("notification").doc(id).update({"isAccepted": isAccepted});
  }
}

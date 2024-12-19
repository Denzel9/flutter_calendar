import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class NotificationService {
  Future<void> send(Map<String, dynamic> user);
  Stream<QuerySnapshot<Map<String, dynamic>>> get(String id);
  Future<void> accept(String userId, String guestId);
  Future<void> delete(String id);
  Future<void> update(String id, bool isAccepted);
}

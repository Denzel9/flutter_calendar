import 'dart:io';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/service/user/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServiceImpl implements UserService {
  late FirebaseFirestore db;

  UserServiceImpl(this.db);

  @override
  bool isLoading = false;

  @override
  Future<void> addUser(Map<String, dynamic> user, String id) async {
    firestore.collection("users").doc(id).set(user);
  }

  @override
  Future<void> setFollowers(String userId, String anotherId) async {
    firestore.collection("users").doc(anotherId).update({
      "followers": FieldValue.arrayUnion([userId])
    });
  }

  @override
  Future<void> setUnFollowers(String userId, String anotherId) async {
    firestore.collection("users").doc(anotherId).update({
      "followers": FieldValue.arrayRemove([userId])
    });
  }

  @override
  Future<void> setFollowing(String userId, String anotherId) async {
    firestore.collection("users").doc(userId).update({
      "following": FieldValue.arrayUnion([anotherId])
    });
  }

  @override
  Future<void> setUnFollowing(String userId, String anotherId) async {
    firestore.collection("users").doc(userId).update({
      "following": FieldValue.arrayRemove([anotherId])
    });
  }

  @override
  Future<void> updateField(String id, String field, String data) async {
    firestore.collection("users").doc(id).update({field: data});
  }

  @override
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> setUser(
      String id) async {
    return firestore.collection("users").doc(id).snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowers(String id) {
    return firestore
        .collection('users')
        .where("following", arrayContains: id)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowings(String id) {
    return firestore
        .collection('users')
        .where("followers", arrayContains: id)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(String usersId) {
    return firestore.collection("users").doc(usersId).snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore.collection("users").snapshots();
  }

  @override
  Future<String?> getAvatar(String id) async {
    return storage.ref().child("$id/avatar.jpg").getDownloadURL();
  }

  @override
  Future<String?> setAvatar(File image, String id) async {
    String? link = '';
    await storage.ref().child("$id/avatar.jpg").putFile(image).then((_) async {
      link = await getAvatar(id);
    });
    return link;
  }
}

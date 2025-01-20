import 'dart:io';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/service/user/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServiceImpl implements UserService {
  @override
  bool isLoading = false;

  @override
  Future<void> addUser(Map<String, dynamic> user, String id) async {
    db.collection("users").doc(id).set(user);
  }

  @override
  Future<bool> setFollow(
      String id, String anotherId, List<dynamic> listFollowing) async {
    isLoading = true;
    if (listFollowing.contains(anotherId)) {
      db.collection("users").doc(id).update({
        "following": FieldValue.arrayRemove([anotherId])
      });
      db.collection("users").doc(anotherId).update({
        "followers": FieldValue.arrayRemove([id])
      });
      return false;
    } else {
      db.collection("users").doc(id).update({
        "following": FieldValue.arrayUnion([anotherId])
      });
      db.collection("users").doc(anotherId).update({
        "followers": FieldValue.arrayUnion([id])
      });
      return true;
    }
  }

  @override
  Future<void> updateField(String id, String field, String data) async {
    db.collection("users").doc(id).update({field: data});
  }

  @override
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> setUser(
      String id) async {
    return db.collection("users").doc(id).snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowers(String id) {
    return db
        .collection('users')
        .where("following", arrayContains: id)
        .snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowings(String id) {
    return db
        .collection('users')
        .where("followers", arrayContains: id)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(String usersId) {
    return db.collection("users").doc(usersId).snapshots();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return db.collection("users").snapshots();
  }

  @override
  Future<String?> getAvatar(String id) async {
    return storage.ref().child("$id/avatar.jpg").getDownloadURL();
  }

  @override
  Future<void> setAvatar(File image, String id) async {
    await storage.ref().child("$id/avatar.jpg").putFile(image);
  }
}

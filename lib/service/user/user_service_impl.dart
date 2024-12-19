import 'dart:io';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/user/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

class UserServiceImpl implements UserService {
  @override
  Future<void> addUser(Map<String, dynamic> user, String id) async {
    db.collection("users").doc(id).set(user);
  }

  @override
  Future<void> setFollow(
      String id, String anotherId, List<dynamic> listFollowing) async {
    if (listFollowing.contains(anotherId)) {
      db.collection("users").doc(id).update({
        "following": FieldValue.arrayRemove([anotherId])
      });
      db.collection("users").doc(anotherId).update({
        "followers": FieldValue.arrayRemove([id])
      });
    } else {
      db.collection("users").doc(id).update({
        "following": FieldValue.arrayUnion([anotherId])
      });
      db.collection("users").doc(anotherId).update({
        "followers": FieldValue.arrayUnion([id])
      });
    }
  }

  @override
  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> setUser(
      String id) async {
    return db.collection("users").doc(id).snapshots();
  }

  @override
  Future<List<dynamic>> getFollowers(String id) async {
    return db
        .collection("users")
        .doc(id)
        .get()
        .then((event) => event.data()?['followers']);
  }

  @override
  Future<List<dynamic>> getFollowing(String id) async {
    return db
        .collection("users")
        .doc(id)
        .get()
        .then((event) => event.data()?['following']);
  }

  @override
  Future<List<User>> getAllUser(String name) async {
    List<User> users = [];
    db.collection("users").snapshots().listen((event) {
      for (var doc in event.docs) {
        final user = User.fromJsonWithId(doc.data(), doc.id);
        if (user.name.toLowerCase().contains(name.toLowerCase())) {
          users.add(user);
        }
      }
    });
    return users;
  }

  @override
  Future<String?> getAvatar(String id) async {
    return storage.ref().child("$id/avatar.jpg").getDownloadURL();
  }

  @override
  Future<void> setAvatar(File image) async {
    // await storage.ref().child("${store?.user.docId}/avatar.jpg").putFile(image);
  }

  @override
  Future<void> setName(String id, String name) async {
    db.collection("users").doc(id).update({"name": name});
  }

  @override
  Future<void> setLastName(String id, String lastName) async {
    db.collection("users").doc(id).update({"lastName": lastName});
  }
}

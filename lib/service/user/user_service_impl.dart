import 'dart:io';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/user/user_service.dart';
import 'package:calendar_flutter/store/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

class UserServiceImpl implements UserService {
  final BuildContext? context;
  UserServiceImpl({this.context});

  @override
  Future<void> addUser(Map<String, dynamic> user, String id) async {
    db.collection("users").doc(id).set(user);
  }

  @override
  Future<void> setFollow(String id, String anotherId) async {
    final store = context?.read<UserStore>();

    if (store?.user.following.contains(anotherId) ?? false) {
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
  Future<User> setUser(String id) async {
    final docRef = db.collection("users").doc(id);
    return await docRef.get().then((DocumentSnapshot doc) =>
        User.fromJsonWithId(doc.data() as Map<String, dynamic>, doc.id));
  }

  @override
  Future<List<User>> getFollowers(String id) async {
    List<User> users = [];
    db
        .collection("users")
        .where("following", arrayContains: id)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        users.add(User.fromJsonWithId(doc.data(), doc.id));
      }
    });
    return users;
  }

  @override
  Future<List<User>> getFollowing(String id) async {
    List<User> users = [];
    db
        .collection("users")
        .where("followers", arrayContains: id)
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        users.add(User.fromJsonWithId(doc.data(), doc.id));
      }
    });
    return users;
  }

  @override
  Future<List<User>> getAllUser(String name) async {
    if (name.isNotEmpty) {
      List<User> users = [];
      db
          .collection("users")
          .where("name", isEqualTo: name[0].toUpperCase() + name.substring(1))
          .snapshots()
          .listen((event) {
        for (var doc in event.docs) {
          final user = User.fromJsonWithId(doc.data(), doc.id);
          users.add(user);
        }
      });
      return users;
    }
    return [];
  }

  @override
  Future<String?> getAvatar([String? link]) async {
    final store = context?.read<UserStore>();
    final ref = link ?? store?.user.docId;
    return storage.ref().child("$ref/avatar.jpg").getDownloadURL();
  }

  @override
  Future<void> setAvatar(File image) async {
    final store = context?.read<UserStore>();
    await storage.ref().child("${store?.user.docId}/avatar.jpg").putFile(image);
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

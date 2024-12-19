import 'dart:io';
import 'package:calendar_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class UserService {
  Future<void> addUser(Map<String, dynamic> user, String id);

  Future<void> setFollow(
      String id, String anotherId, List<dynamic> listFollowing);

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> setUser(String id);

  Future<List<dynamic>> getFollowers(String id);

  Future<List<dynamic>> getFollowing(String id);

  Future<List<User>> getAllUser(String name);

  Future<String?> getAvatar(String id);

  Future<void> setAvatar(File image);

  Future<void> setName(String id, String name);

  Future<void> setLastName(String id, String lastName);
}

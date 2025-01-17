import 'dart:io';
import 'package:calendar_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class UserService {
  bool isLoading = false;

  Future<void> addUser(Map<String, dynamic> user, String id);

  Future<bool> setFollow(
      String id, String anotherId, List<dynamic> listFollowing);

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> setUser(String id);

  Future<List<User>> getFollowers(String id);

  Future<List<User>> getFollowings(String id);

  Future<List<dynamic>> getUser(List<String> usersId);

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser();

  Future<String?> getAvatar(String id);

  Future<void> setAvatar(File image, String id);

  Future<void> updateField(String id, String field, String data);
}

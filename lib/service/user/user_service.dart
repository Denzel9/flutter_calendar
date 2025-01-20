import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class UserService {
  bool isLoading = false;

  Future<void> addUser(Map<String, dynamic> user, String id);

  Future<bool> setFollow(
      String id, String anotherId, List<dynamic> listFollowing);

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> setUser(String id);

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowers(String id);

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowings(String id);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(String usersId);

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser();

  Future<String?> getAvatar(String id);

  Future<void> setAvatar(File image, String id);

  Future<void> updateField(String id, String field, String data);
}

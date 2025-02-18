import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class UserService {
  bool isLoading = false;

  Future<void> addUser(Map<String, dynamic> user, String id);

  Future<void> setFollowers(String id, String anotherId);

  Future<void> setFollowing(String id, String anotherId);

  Future<void> setUnFollowers(String id, String anotherId);

  Future<void> setUnFollowing(String id, String anotherId);

  Future<Stream<DocumentSnapshot<Map<String, dynamic>>>> setUser(String id);

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowers(String id);

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowings(String id);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(String usersId);

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser();

  Future<String?> getAvatar(String id);

  Future<String?> setAvatar(File image, String id);

  Future<void> updateField(String id, String field, String data);
}

import 'dart:io';
import 'package:calendar_flutter/models/user.dart';

abstract interface class UserService {
  Future<void> addUser(Map<String, dynamic> user, String id);

  Future<void> setFollow(String id, String anotherId);

  Future<User?> setUser(String id);

  Future<List<User>> getFollowers(String id);

  Future<List<User>> getFollowing(String id);

  Future<List<User>> getAllUser(String name);

  Future<String?> getAvatar([String? link]);

  Future<void> setAvatar(File image);

  Future<void> setName(String id, String name);

  Future<void> setLastName(String id, String lastName);
}

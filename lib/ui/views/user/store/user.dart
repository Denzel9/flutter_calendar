import 'dart:io';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStoreLocal = XStore with _$UserStoreLocal;

final UserServiceImpl _userService = UserServiceImpl(firestore);

abstract class XStore with Store {
  @observable
  bool isEdit = false;

  @observable
  UserModel user = UserModel(
      name: '',
      lastName: '',
      email: '',
      following: [],
      followers: [],
      avatar: '');

  @observable
  File? image;

  @observable
  bool isGuest = false;

  @action
  Future<Null> getUser(String id) async {
    isGuest = true;
    Stream<DocumentSnapshot<Map<String, dynamic>>> query =
        _userService.getUser(id);
    query.listen((event) {
      user = UserModel.fromJsonWithId(event.data(), event.id);
    });
  }

  @action
  Future<Null> reset() async {
    isGuest = false;
    user = UserModel(
        name: '',
        lastName: '',
        email: '',
        following: [],
        followers: [],
        avatar: '');
  }
}

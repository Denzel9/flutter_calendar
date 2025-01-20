import 'dart:io';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStoreLocal = XStore with _$UserStoreLocal;

final UserServiceImpl userService = UserServiceImpl();

UserServiceImpl _userService = UserServiceImpl();

abstract class XStore with Store {
  @observable
  bool isEdit = false;

  @observable
  User? user;

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
      user = User.fromJsonWithId(event.data(), event.id);
    });
  }
}

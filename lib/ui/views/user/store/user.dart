import 'dart:io';
import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/utils/empty_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStoreLocal = XStore with _$UserStoreLocal;

abstract class XStore with Store {
  @observable
  bool isEdit = false;

  @observable
  UserModel user = emptyUser;

  @observable
  File? image;

  @observable
  bool isGuest = false;

  @observable
  int attachmentsCount = 0;

  @observable
  List<String?> collaborationUserIds = [];

  @action
  Future<Null> getUser(String id) async {
    isGuest = true;
    Stream<DocumentSnapshot<Map<String, dynamic>>> query =
        userService.getUser(id);
    query.listen((event) {
      user = UserModel.fromJsonWithId(event.data(), event.id);
    });
  }

  @action
  Future<Null> reset() async {
    isGuest = false;
    user = emptyUser;
  }
}

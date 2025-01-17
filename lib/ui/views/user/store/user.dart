import 'dart:io';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStoreLocal = XStore with _$UserStoreLocal;

final UserServiceImpl userService = UserServiceImpl();

abstract class XStore with Store {
  @observable
  bool isEdit = false;

  @observable
  User? user;

  @observable
  File? image;
}

import 'dart:io';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStoreLocal = XStore with _$UserStoreLocal;

abstract class XStore with Store {
  @observable
  bool isEdit = false;

  @observable
  String guestId = '';

  @observable
  File? image;
}

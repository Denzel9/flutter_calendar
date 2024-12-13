import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:mobx/mobx.dart';

part 'user.g.dart';

class UserStore = XStore with _$UserStore;

abstract class XStore with Store {
  @observable
  User user = User(
    name: '',
    lastName: '',
    email: '',
    docId: '',
    following: [],
    followers: [],
  );

  @action
  setUser(String id) async {
    final userService = UserServiceImpl();
    userService.setUser(id).then((response) => user = response);
  }
}

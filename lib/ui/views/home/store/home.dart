import 'package:mobx/mobx.dart';

part 'home.g.dart';

class HomeStoreLocal = XStore with _$HomeStoreLocal;

abstract class XStore with Store {
  @observable
  bool isActiveTask = true;

  @observable
  bool isCollaborationTasks = false;
}

import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/image_store/image_store.dart';
import 'package:mobx/mobx.dart';

part 'board.g.dart';

class BoardStoreLocal = XStore with _$BoardStoreLocal;

abstract class XStore with Store {
  @observable
  List<TaskModel> tasks = [];

  @observable
  List<ImageData> deletingList = [];

  @observable
  bool isDeleting = false;
}

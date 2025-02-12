import 'dart:io';

import 'package:mobx/mobx.dart';

part 'task.g.dart';

class TaskStoreLocal = XStore with _$TaskStoreLocal;

abstract class XStore with Store {
  @observable
  String currentBoard = '';

  @observable
  bool isEdit = false;

  @observable
  bool isDoneTask = false;

  @observable
  List<File> image = [];

  @observable
  List<String> links = [];

  @observable
  bool isDeleting = false;
}

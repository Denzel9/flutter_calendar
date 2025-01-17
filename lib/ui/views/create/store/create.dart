import 'dart:io';
import 'package:mobx/mobx.dart';

part 'create.g.dart';

class CreateStoreLocal = XStore with _$CreateStoreLocal;

abstract class XStore with Store {
  @observable
  List<String> boards = [];

  @observable
  List<String> assign = [];

  @observable
  String board = 'Default';

  @observable
  String taskTitle = '';

  @observable
  String taskDescription = '';

  @observable
  String boardTitle = '';

  @observable
  String boardDescription = '';

  @observable
  bool isEdit = false;

  @observable
  List<File> image = [];
}

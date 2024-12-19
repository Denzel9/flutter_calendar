import 'package:calendar_flutter/models/board.dart';
import 'package:mobx/mobx.dart';

part 'board.g.dart';

class BoardStore = XStore with _$BoardStore;

abstract class XStore with Store {
  @observable
  List<Board> board = [];

  @observable
  String title = '';

  @observable
  String description = '';

  @action
  Future addBoard(List<Board> newBoards) async {
    board.clear();
    board = ObservableList.of(newBoards);
  }
}

import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/board/board_service_impl.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

TaskServiceImpl taskService = TaskServiceImpl();
UserServiceImpl userService = UserServiceImpl();
BoardServiceImpl boardService = BoardServiceImpl();

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  ObservableList<Task> tasks = ObservableList<Task>.of([]);

  @observable
  ObservableList<Board> boards = ObservableList<Board>.of([]);

  @observable
  User? user;

  @observable
  DateTime selectedDate = now;

  @action
  Future<Null> setUser(String id) async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> query =
        await userService.setUser(id);
    query.listen((event) {
      user = User.fromJsonWithId(event.data(), event.id);
    });
  }

  @action
  void initState() {
    fetchTasks();
    fetchBoards();
  }

  @action
  Future<Null> fetchTasks() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> query =
        await taskService.getTasks();
    query.listen((event) {
      final List<Task> listTasks = [];
      for (var doc in event.docs) {
        listTasks.add(
            Task.fromJsonWithId(doc.data() as Map<String, dynamic>?, doc.id));
      }
      tasks = ObservableList.of(listTasks);
    });
  }

  @observable
  bool isAllTask = false;

  @observable
  bool isActiveTask = false;

  @computed
  List<Task> get todayTasks => tasks
      .where((task) =>
          getSliceDate(task.createdAt) == getSliceDate(selectedDate.toString()))
      .toList();

  @computed
  List<Task> get listAllTask => tasks;

  @computed
  List<Task> get listActiveTask => tasks.where((task) => task.done).toList();

  @action
  Future<Null> fetchBoards() async {
    Stream<QuerySnapshot<Map<String, dynamic>>> query =
        await boardService.getBoards();
    query.listen((event) {
      final List<Board> listBoards = [];
      for (var doc in event.docs) {
        listBoards.add(
            Board.fromJsonWithId(doc.data() as Map<String, dynamic>?, doc.id));
      }
      boards = ObservableList.of(listBoards);
    });
  }
}

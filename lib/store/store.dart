import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/empty_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  final FirebaseFirestore firestore;

  AppStoreBase(this.firestore);

  @observable
  ObservableList<TaskModel> tasks = ObservableList<TaskModel>.of([]);

  @observable
  ObservableList<Board> boards = ObservableList<Board>.of([]);

  @observable
  UserModel user = emptyUser;

  @observable
  DateTime selectedDate = now;

  @computed
  List<TaskModel> get collaborationTasks =>
      tasks.where((task) => task.isCollaborated == true).toList();

  @computed
  List<TaskModel> get todayTasks => tasks
      .where((task) =>
          getSliceDate(task.date) == getSliceDate(selectedDate.toString()))
      .toList();

  @computed
  List<TaskModel> get listArchiveTasks =>
      todayTasks.where((task) => task.done).toList();

  @computed
  List<TaskModel> get listAllTask => tasks;

  @computed
  List<TaskModel> get listActiveTask =>
      todayTasks.where((task) => !task.done).toList();

  @computed
  List<TaskModel> get listCollaborationTask =>
      todayTasks.where((task) => task.isCollaborated).toList();

  @computed
  List<TaskModel> get listAllCollaborationTask =>
      tasks.where((task) => task.isCollaborated).toList();

  @computed
  List<TaskModel> get nextTasks => tasks
      .where((task) =>
          getSliceDay(task.date.toString()) >
          getSliceDay(selectedDate.toString()))
      .toList();

  @action
  Future setUser(String id) async {
    final query = await userService.setUser(id);
    query.listen((event) {
      user = UserModel.fromJsonWithId(event.data(), event.id);
    });
  }

  @action
  Future<void> fetchTasks(String id) async {
    final query = taskService.getTasks(id);

    query.listen((event) {
      final List<TaskModel> tasksList = event.docs
          .map((doc) => TaskModel.fromJsonWithId(doc.data(), doc.id))
          .toList();
      tasks = ObservableList.of(tasksList);
    });
  }

  @action
  Future<void> fetchBoards(String id) async {
    final query = boardService.getBoards(id);

    query.listen((event) {
      final List<Board> listBoards = [];
      for (final doc in event.docs) {
        listBoards.add(Board.fromJsonWithId(doc.data(), doc.id));
      }

      boards = ObservableList.of(listBoards);
    });
  }

  @action
  Future<void> initState(String id) async {
    await Future.wait([
      fetchTasks(id),
      fetchBoards(id),
    ]);
  }

  void reset() {
    tasks = ObservableList.of([]);
    boards = ObservableList.of([]);
    user = emptyUser;
  }
}

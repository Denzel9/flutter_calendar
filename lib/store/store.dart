import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  final FirebaseFirestore firestore;

  AppStoreBase(this.firestore);

  @observable
  ObservableList<TaskModel> ownTasks = ObservableList<TaskModel>.of([]);

  @observable
  ObservableList<TaskModel> collaborationTasks =
      ObservableList<TaskModel>.of([]);

  @observable
  ObservableList<Board> boards = ObservableList<Board>.of([]);

  @observable
  UserModel user = UserModel(
      name: '',
      lastName: '',
      email: '',
      docId: '',
      following: [],
      followers: []);

  @observable
  DateTime selectedDate = now;

  @computed
  List<TaskModel> get tasks => [...ownTasks, ...collaborationTasks];

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
  Future<Null> setUser(String id) async {
    Stream<DocumentSnapshot<Map<String, dynamic>>> query =
        await userService.setUser(id);
    query.listen((event) {
      user = UserModel.fromJsonWithId(event.data(), event.id);
    });
  }

  @action
  Future<Null> fetchCollaborationTasks(String id) async {
    Stream<QuerySnapshot<Map<String, dynamic>>> query =
        await taskService.getCollaborationTasks(id);

    query.listen((event) {
      final List<TaskModel> listTasks = [];
      for (var doc in event.docs) {
        listTasks.add(TaskModel.fromJsonWithId(
            doc.data() as Map<String, dynamic>?, doc.id));
      }

      collaborationTasks = ObservableList.of(listTasks);
    });
  }

  @action
  Future<Null> fetchTasks(String id) async {
    Stream<QuerySnapshot<Map<String, dynamic>>> query =
        await taskService.getTasks(id);

    query.listen((event) {
      final List<TaskModel> listTasks = [];
      for (var doc in event.docs) {
        listTasks.add(TaskModel.fromJsonWithId(
            doc.data() as Map<String, dynamic>?, doc.id));
      }

      ownTasks = ObservableList.of(listTasks);
    });
  }

  @action
  Future<Null> fetchBoards(String id) async {
    Stream<QuerySnapshot<Map<String, dynamic>>> query =
        await boardService.getBoards(id);

    query.listen((event) {
      final List<Board> listBoards = [];
      for (var doc in event.docs) {
        listBoards.add(
            Board.fromJsonWithId(doc.data() as Map<String, dynamic>?, doc.id));
      }

      boards = ObservableList.of(listBoards);
    });
  }

  @action
  void initState(String id) {
    fetchTasks(id);
    fetchCollaborationTasks(id);
    fetchBoards(id);
  }
}

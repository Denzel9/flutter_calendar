import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:mobx/mobx.dart';

part 'task.g.dart';

class TaskStore = XStore with _$TaskStore;

abstract class XStore with Store {
  @observable
  List<Task> tasks = [];

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  bool isAllTask = false;

  @observable
  bool isActiveTask = false;

  @computed
  List<Task> get listAllTask => tasks;

  @computed
  List<Task> get listActiveTask => tasks.where((task) => task.done).toList();

  @action
  void addTask(List<Task> listTask) {
    tasks = listTask;
  }

  @action
  Future getTasks() async {
    final userId = await localStorage.getItem('id');
    db.collection("tasks").where("docId", isEqualTo: userId).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final task = Task.fromJsonWithId(docSnapshot.data(), docSnapshot.id);
          if (task.title.isNotEmpty) tasks.add(task);
        }
      },
    );
  }
}

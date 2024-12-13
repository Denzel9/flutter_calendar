import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/service/task/task_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskServiceImpl implements TaskService {
  @override
  Future<String> addTask(Map<String, dynamic> task) async {
    return db
        .collection("tasks")
        .add(task)
        .then((DocumentReference doc) => doc.id);
  }

  @override
  Future<QuerySnapshot> getTasks([String? id]) async {
    final userId = id ?? await localStorage.getItem('id');
    return db.collection('tasks').where('docId', isEqualTo: userId).get();
  }

  @override
  Future<void> deleteTask(String id) async {
    db.collection("tasks").doc(id).delete();
  }

  @override
  Future<void> changeDone(String id, bool done) async {
    db.collection("tasks").doc(id).update({"done": done});
  }

  @override
  Future<void> changeTitle(String id, String title) async {
    db.collection("tasks").doc(id).update({"title": title});
  }

  @override
  Future<void> updateField(String id, String field, String data) async {
    db.collection("tasks").doc(id).update({field: data});
  }
}

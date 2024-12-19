import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class TaskService {
  Future<String> addTask(Map<String, dynamic> task);

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getTasks(String id);

  Future<int> getTasksCount(String userId);

  Future<void> deleteTask(String id);

  Future<void> changeDone(String id, bool done);

  Future<void> changeTitle(String id, String title);

  Future<void> updateField(String id, String field, String data);
}

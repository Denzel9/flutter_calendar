import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class TaskService {
  bool isLoading = false;

  Future<String> addTask(Map<String, dynamic> task);

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getTasks(String id);

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getCollaborationTasks(
      String id);

  Future<void> editAssign(String id, List<dynamic> listAssigned);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getTask(String id);

  Future<int> getTasksCount(String userId);

  Future<void> deleteTask(String id);

  Future<void> changeDone(String id, bool done);

  Future<void> changeTitle(String id, String title);

  Future<void> updateField(String id, String field, String data);

  Future<void> addAttachments(List<File> images, String id);

  Future<List<String>> getAttachments(String id);
}

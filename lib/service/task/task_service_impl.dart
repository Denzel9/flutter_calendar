import 'dart:io';
import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:calendar_flutter/service/task/task_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskServiceImpl implements TaskService {
  @override
  bool isLoading = false;

  @override
  Future<String> addTask(Map<String, dynamic> task) async {
    isLoading = true;
    return db.collection("tasks").add(task).then((DocumentReference doc) {
      isLoading = false;
      return doc.id;
    });
  }

  @override
  Future<void> deleteTask(String id) async {
    db.collection("tasks").doc(id).delete();
  }

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getTasks(
      String id) async {
    return db.collection("tasks").where("userId", isEqualTo: id).snapshots();
  }

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getCollaborationTasks(
      String id) async {
    return db
        .collection("tasks")
        .where("assign", arrayContains: id)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getTask(String id) {
    return db.collection('tasks').doc(id).snapshots();
  }

  @override
  Future<void> updateField(String id, String field, String data) async {
    db.collection("tasks").doc(id).update({field: data});
  }

  @override
  Future<int> getTasksCount(String userId) async {
    final resp =
        await db.collection("tasks").where("userId", isEqualTo: userId).get();
    return resp.docs.length;
  }

  @override
  Future<void> editAssign(String id, List<dynamic> listAssigned) async {
    db
        .collection("tasks")
        .doc(id)
        .update({"assign": listAssigned, 'isCollaborated': true});
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
  Future<void> addAttachments(List<File> images, String id) async {
    isLoading = true;
    for (final image in images) {
      await storage
          .ref()
          .child("task_$id/attachments/${image.hashCode}.jpg")
          .putFile(image);
    }
  }

  @override
  Future<List<String>> getAttachments(String id) async {
    final List<String> listAttachments = [];
    await storage
        .ref()
        .child("task_$id/attachments")
        .listAll()
        .then((res) async {
      for (final image in res.items) {
        final imageLink = await image.getDownloadURL();
        listAttachments.add(imageLink);
      }
    });
    return listAttachments;
  }
}

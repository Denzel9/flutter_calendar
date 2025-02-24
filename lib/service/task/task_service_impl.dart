import 'dart:io';
import 'package:calendar_flutter/core/controller/controller.dart';
import 'package:calendar_flutter/service/task/task_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskServiceImpl implements TaskService {
  final FirebaseFirestore firestore;

  TaskServiceImpl(this.firestore);

  bool isLoading = false;

  @override
  Future<String> addTask(Map<String, dynamic> task) async {
    isLoading = true;
    return firestore
        .collection("tasks")
        .add(task)
        .then((DocumentReference doc) => doc.id);
  }

  @override
  Future<void> deleteTask(String id) async {
    isLoading = true;
    firestore.collection("tasks").doc(id).delete();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getTasks(String id) =>
      firestore.collection("tasks").where("userId", isEqualTo: id).snapshots();

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getCollaborationTasks(
          String id) =>
      firestore
          .collection("tasks")
          .where("assign", arrayContains: id)
          .where("userId", isNotEqualTo: id)
          .snapshots();

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getTask(String id) =>
      firestore.collection('tasks').doc(id).snapshots();

  @override
  Future<void> updateField(String id, String field, dynamic data) =>
      firestore.collection("tasks").doc(id).update({field: data});

  @override
  Future<int> getTasksCount(String userId) async {
    final resp = await firestore
        .collection("tasks")
        .where("userId", isEqualTo: userId)
        .get();
    return resp.docs.length;
  }

  @override
  Future<void> editAssign(String id, List<dynamic> listAssigned) => firestore
      .collection("tasks")
      .doc(id)
      .update({"assign": listAssigned, 'isCollaborated': true});

  @override
  Future<void> changeDone(String id, bool done) =>
      firestore.collection("tasks").doc(id).update({"done": done});

  @override
  Future<void> changeTitle(String id, String title) =>
      firestore.collection("tasks").doc(id).update({"title": title});

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

  @override
  Future<void> deleteAttachments(
    String id,
    String image,
  ) =>
      storage.ref().child("task_$id/attachments/$image.jpg").delete();
}

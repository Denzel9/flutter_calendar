import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_flutter/service/board/board_service.dart';

class BoardServiceImpl implements BoardService {
  @override
  Future<String> addBoard(Map<String, dynamic> board) async {
    return db
        .collection("boards")
        .add(board)
        .then((DocumentReference doc) => doc.id);
  }

  @override
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getBoards(
      String id) async {
    return db.collection('boards').where('userId', isEqualTo: id).snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getBoard(String id) {
    return db.collection('boards').doc(id).snapshots();
  }

  @override
  Future<void> updateField(String id, String field, String data) async {
    db.collection("boards").doc(id).update({field: data});
  }

  @override
  Future<void> deleteBoard(String id) async {
    db.collection("boards").doc(id).delete();
  }

  @override
  Future<void> addTask(String boardId, String taskId) async {
    db.collection("boards").doc(boardId).update({
      "tasks": FieldValue.arrayUnion([taskId])
    });
  }

  @override
  Future<void> deleteTask(String boardId, String taskId) async {
    db.collection("boards").doc(boardId).update({
      "tasks": FieldValue.arrayRemove([taskId])
    });
  }
}

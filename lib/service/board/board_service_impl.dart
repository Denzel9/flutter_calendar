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
  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getBoards() async {
    final userId = await localStorage.getItem('id');
    return db
        .collection('boards')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  @override
  Future<void> deleteBoard(String id) async {
    db.collection("boards").doc(id).delete();
  }

  @override
  Future<void> changeTitle(String id, String title) async {
    db.collection("boards").doc(id).update({"title": title});
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

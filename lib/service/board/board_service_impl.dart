import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_flutter/service/board/board_service.dart';

class BoardServiceImpl implements BoardService {
  final FirebaseFirestore firestore;

  BoardServiceImpl(this.firestore);

  bool isLoading = false;

  @override
  Future<String> addBoard(Map<String, dynamic> board) {
    isLoading = true;
    return firestore
        .collection("boards")
        .add(board)
        .then((DocumentReference doc) => doc.id);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getBoards(String id) =>
      firestore.collection('boards').where('userId', isEqualTo: id).snapshots();

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getBoard(String id) =>
      firestore.collection('boards').doc(id).snapshots();

  @override
  Future<void> updateField(String id, String field, String data) =>
      firestore.collection("boards").doc(id).update({field: data});

  @override
  Future<void> deleteBoard(String id) =>
      firestore.collection("boards").doc(id).delete();

  @override
  Future<void> addTask(String boardId, String taskId) =>
      firestore.collection("boards").doc(boardId).update({
        "tasks": FieldValue.arrayUnion([taskId])
      });

  @override
  Future<void> deleteTask(String boardId, String taskId) =>
      firestore.collection("boards").doc(boardId).update({
        "tasks": FieldValue.arrayRemove([taskId])
      });
}

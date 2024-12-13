import 'package:calendar_flutter/core/controller/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_flutter/models/board.dart';
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
  Future<List<Board>?> getBoards() async {
    final id = await localStorage.getItem('id');
    List<Board> boards = [];
    db.collection("boards").where("userId", isEqualTo: id).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          final board =
              Board.fromJsonWithId(docSnapshot.data(), docSnapshot.id);
          boards.add(board);
        }
      },
    );

    return boards;
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

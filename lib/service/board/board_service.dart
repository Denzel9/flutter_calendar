import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class BoardService {
  Future<String> addBoard(Map<String, dynamic> board);

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getBoards();

  Future<void> deleteBoard(String id);

  Future<void> changeTitle(String id, String title);

  Future<void> addTask(String boardId, String taskId);

  Future<void> deleteTask(String boardId, String taskId);
}

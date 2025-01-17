import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class BoardService {
  Future<String> addBoard(Map<String, dynamic> board);

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getBoards(String id);

  Stream<DocumentSnapshot<Map<String, dynamic>>> getBoard(String id);

  Future<void> deleteBoard(String id);

  Future<void> addTask(String boardId, String taskId);

  Future<void> deleteTask(String boardId, String taskId);

  Future<void> updateField(String id, String field, String data);
}

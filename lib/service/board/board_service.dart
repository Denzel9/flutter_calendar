import 'package:calendar_flutter/models/board.dart';

abstract interface class BoardService {
  Future<String> addBoard(Map<String, dynamic> board);

  Future<List<Board>?> getBoards();

  Future<void> deleteBoard(String id);

  Future<void> changeTitle(String id, String title);

  Future<void> addTask(String boardId, String taskId);

  Future<void> deleteTask(String boardId, String taskId);
}

import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/utils/date.dart';

List<TaskModel> filteredTask({
  required AppStore store,
  DateTime? date,
  String? searchText,
  bool? isAllTask,
  bool? isCollaborationTasks,
  bool? isActiveTask = false,
  bool? isArchive,
}) {
  if (isAllTask ?? false) {
    if (isCollaborationTasks ?? false) {
      return store.listAllCollaborationTask;
    }
    return store.listAllTask
        .where((task) => task.title.contains(searchText ?? ''))
        .toList();
  }

  if (isCollaborationTasks ?? false) {
    return store.listCollaborationTask;
  }

  if (date != null) {
    return store.tasks
        .where((task) =>
            task.title.contains(searchText ?? '') &&
            getSliceDate(task.date) == getSliceDate(date.toString()))
        .toList();
  }

  if (isActiveTask ?? false) {
    return store.listActiveTask
        .where((task) => task.title.contains(searchText ?? ''))
        .toList();
  }

  if (isArchive ?? false) {
    return store.listArchiveTasks
        .where((task) => task.title.contains(searchText ?? ''))
        .toList();
  }

  return store.todayTasks
      .where((task) => task.title.contains(searchText ?? ''))
      .toList();
}

List<Board> filteredBoards(
  List<Board> boards,
  String? searchText,
) {
  return boards
      .where((board) =>
          board.title.toLowerCase().contains(searchText?.toLowerCase() ?? ''))
      .toList();
}

List<TaskModel> filteredTaskToBoard(
  String boardTitle,
  AppStore store,
) {
  return store.tasks
      .where(
          (task) => task.board == boardTitle && task.userId == store.user.docId)
      .toList();
}

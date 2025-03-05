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
    return store.listAllTask
        .where((task) =>
            task.title.contains(searchText ?? '') &&
            getSliceDate(task.date) == getSliceDate(date.toString()))
        .toList();
  }

  if (isActiveTask ?? false) {
    return store.listOpenedTask
        .where((task) => task.title.contains(searchText ?? ''))
        .toList();
  }

  if (isArchive ?? false) {
    return store.listClosedTasks
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
  List<TaskModel> sortedTasks = [...store.listAllTask];

  sortedTasks.sort((a, b) {
    DateTime firstDate = DateTime.parse(a.date);
    DateTime secondDate = DateTime.parse(b.date);

    bool isFirstToday = isToday(a.date);
    bool isSecondToday = isToday(b.date);

    if (isFirstToday && isSecondToday) {
      return firstDate.compareTo(secondDate);
    } else if (isFirstToday) {
      return -1;
    } else if (isSecondToday) {
      return 1;
    } else {
      return firstDate.compareTo(secondDate);
    }
  });

  return sortedTasks
      .where(
          (task) => task.board == boardTitle && task.userId == store.user.docId)
      .toList();
}

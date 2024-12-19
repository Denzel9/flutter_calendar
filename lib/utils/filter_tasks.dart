import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/utils/date.dart';

List<Task> filteredTask(
    {DateTime? date, String? searchText, required AppStore store}) {
  if (store.isAllTask) {
    return store.listAllTask;
  }
  if (store.isActiveTask) {
    return store.listActiveTask
        .where((task) =>
            getSliceDate(task.date) == getSliceDate(date.toString()) &&
            task.title.contains(searchText ?? ''))
        .toList();
  }
  return store.tasks
      .where((task) =>
          getSliceDate(task.date) == getSliceDate(date.toString()) &&
          !task.done &&
          task.title.contains(searchText ?? ''))
      .toList();
}

List<Task> filteredTaskToBoard(String boardTitle, List<Task> tasks) {
  return tasks.where((task) => task.board == boardTitle).toList();
}

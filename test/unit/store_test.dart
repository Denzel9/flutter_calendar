import 'package:calendar_flutter/store/store.dart';
import 'package:calendar_flutter/utils/date.dart';
import 'package:calendar_flutter/utils/filter_tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../data/data.dart';

void main() {
  final firestore = FakeFirebaseFirestore();
  final store = AppStore(firestore);

  setUpAll(() async {
    await Future.wait([
      firestore.collection('tasks').add(task.toJson()),
      firestore.collection('tasks').add(collaborationTask.toJson()),
      firestore.collection('boards').add(board.toJson())
    ]);

    store.initState('userId');
  });

  group('Test main store', () {
    test('Tasks is not empty', () async {
      expect(store.tasks.length, 1);
    });

    test('Collaboration tasks is not empty', () async {
      expect(store.collaborationTasks.length, 1);
    });

    test('Boards is not empty', () async {
      expect(store.boards.length, 1);
    });

    test('List all task is not empty', () async {
      expect(store.listAllTask.length, 2);
    });
  });

  group('Test calendar', () {
    test('Test compute month', () async {
      DateTimeRange dateTimeRange = DateTimeRange(
        start: DateTime(now.year, now.month + 1),
        end: DateTime(now.year, now.month + 2),
      );

      final daysToGenerate =
          dateTimeRange.end.difference(dateTimeRange.start).inDays;

      final listDate =
          generateCalendar(now.month).length - getWeekday(now.month);
      expect(listDate, daysToGenerate);
    });
    test('List all task is not empty', () async {
      final dates = computeDates(12);
      expect(dates.length, 12);
    });
  });

  group('Test filter tasks', () {
    test('List todayTask task  is not empty', () async {
      final tasks = filteredTask(store: store);
      expect(tasks.length, 1);
    });

    test('List task with "isAllTask" is not empty', () async {
      final tasks = filteredTask(store: store, isAllTask: true);
      expect(tasks.length, 2);
    });
    test('List task with "isCollaborationTasks" is not empty', () async {
      final tasks = filteredTask(store: store, isCollaborationTasks: true);
      expect(tasks.length, 1);
    });

    test('List task with "date" is not empty', () async {
      final tasks = filteredTask(store: store, date: now);
      expect(tasks.length, 1);
    });
  });
}

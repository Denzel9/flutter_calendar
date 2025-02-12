import 'package:calendar_flutter/store/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import '../data/data.dart';

final class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

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
      expect(store.tasks.length, 2);
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
}

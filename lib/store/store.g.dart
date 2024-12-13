// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on AppStoreBase, Store {
  Computed<List<Task>>? _$listAllTaskComputed;

  @override
  List<Task> get listAllTask =>
      (_$listAllTaskComputed ??= Computed<List<Task>>(() => super.listAllTask,
              name: 'AppStoreBase.listAllTask'))
          .value;
  Computed<List<Task>>? _$listActiveTaskComputed;

  @override
  List<Task> get listActiveTask => (_$listActiveTaskComputed ??=
          Computed<List<Task>>(() => super.listActiveTask,
              name: 'AppStoreBase.listActiveTask'))
      .value;

  late final _$tasksAtom = Atom(name: 'AppStoreBase.tasks', context: context);

  @override
  ObservableList<Task> get tasks {
    _$tasksAtom.reportRead();
    return super.tasks;
  }

  @override
  set tasks(ObservableList<Task> value) {
    _$tasksAtom.reportWrite(value, super.tasks, () {
      super.tasks = value;
    });
  }

  late final _$boardsAtom = Atom(name: 'AppStoreBase.boards', context: context);

  @override
  ObservableList<Board> get boards {
    _$boardsAtom.reportRead();
    return super.boards;
  }

  @override
  set boards(ObservableList<Board> value) {
    _$boardsAtom.reportWrite(value, super.boards, () {
      super.boards = value;
    });
  }

  late final _$userAtom = Atom(name: 'AppStoreBase.user', context: context);

  @override
  User? get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User? value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$isAllTaskAtom =
      Atom(name: 'AppStoreBase.isAllTask', context: context);

  @override
  bool get isAllTask {
    _$isAllTaskAtom.reportRead();
    return super.isAllTask;
  }

  @override
  set isAllTask(bool value) {
    _$isAllTaskAtom.reportWrite(value, super.isAllTask, () {
      super.isAllTask = value;
    });
  }

  late final _$isActiveTaskAtom =
      Atom(name: 'AppStoreBase.isActiveTask', context: context);

  @override
  bool get isActiveTask {
    _$isActiveTaskAtom.reportRead();
    return super.isActiveTask;
  }

  @override
  set isActiveTask(bool value) {
    _$isActiveTaskAtom.reportWrite(value, super.isActiveTask, () {
      super.isActiveTask = value;
    });
  }

  late final _$setUserAsyncAction =
      AsyncAction('AppStoreBase.setUser', context: context);

  @override
  Future setUser(String id) {
    return _$setUserAsyncAction.run(() => super.setUser(id));
  }

  late final _$fetchTasksAsyncAction =
      AsyncAction('AppStoreBase.fetchTasks', context: context);

  @override
  Future<Null> fetchTasks() {
    return _$fetchTasksAsyncAction.run(() => super.fetchTasks());
  }

  late final _$AppStoreBaseActionController =
      ActionController(name: 'AppStoreBase', context: context);

  @override
  void initState() {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.initState');
    try {
      return super.initState();
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tasks: ${tasks},
boards: ${boards},
user: ${user},
isAllTask: ${isAllTask},
isActiveTask: ${isActiveTask},
listAllTask: ${listAllTask},
listActiveTask: ${listActiveTask}
    ''';
  }
}

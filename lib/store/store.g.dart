// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on AppStoreBase, Store {
  Computed<List<TaskModel>>? _$tasksComputed;

  @override
  List<TaskModel> get tasks =>
      (_$tasksComputed ??= Computed<List<TaskModel>>(() => super.tasks,
              name: 'AppStoreBase.tasks'))
          .value;
  Computed<List<TaskModel>>? _$todayTasksComputed;

  @override
  List<TaskModel> get todayTasks => (_$todayTasksComputed ??=
          Computed<List<TaskModel>>(() => super.todayTasks,
              name: 'AppStoreBase.todayTasks'))
      .value;
  Computed<List<TaskModel>>? _$listArchiveTasksComputed;

  @override
  List<TaskModel> get listArchiveTasks => (_$listArchiveTasksComputed ??=
          Computed<List<TaskModel>>(() => super.listArchiveTasks,
              name: 'AppStoreBase.listArchiveTasks'))
      .value;
  Computed<List<TaskModel>>? _$listAllTaskComputed;

  @override
  List<TaskModel> get listAllTask => (_$listAllTaskComputed ??=
          Computed<List<TaskModel>>(() => super.listAllTask,
              name: 'AppStoreBase.listAllTask'))
      .value;
  Computed<List<TaskModel>>? _$listActiveTaskComputed;

  @override
  List<TaskModel> get listActiveTask => (_$listActiveTaskComputed ??=
          Computed<List<TaskModel>>(() => super.listActiveTask,
              name: 'AppStoreBase.listActiveTask'))
      .value;
  Computed<List<TaskModel>>? _$listCollaborationTaskComputed;

  @override
  List<TaskModel> get listCollaborationTask =>
      (_$listCollaborationTaskComputed ??= Computed<List<TaskModel>>(
              () => super.listCollaborationTask,
              name: 'AppStoreBase.listCollaborationTask'))
          .value;
  Computed<List<TaskModel>>? _$listAllCollaborationTaskComputed;

  @override
  List<TaskModel> get listAllCollaborationTask =>
      (_$listAllCollaborationTaskComputed ??= Computed<List<TaskModel>>(
              () => super.listAllCollaborationTask,
              name: 'AppStoreBase.listAllCollaborationTask'))
          .value;
  Computed<List<TaskModel>>? _$nextTasksComputed;

  @override
  List<TaskModel> get nextTasks =>
      (_$nextTasksComputed ??= Computed<List<TaskModel>>(() => super.nextTasks,
              name: 'AppStoreBase.nextTasks'))
          .value;

  late final _$ownTasksAtom =
      Atom(name: 'AppStoreBase.ownTasks', context: context);

  @override
  ObservableList<TaskModel> get ownTasks {
    _$ownTasksAtom.reportRead();
    return super.ownTasks;
  }

  @override
  set ownTasks(ObservableList<TaskModel> value) {
    _$ownTasksAtom.reportWrite(value, super.ownTasks, () {
      super.ownTasks = value;
    });
  }

  late final _$collaborationTasksAtom =
      Atom(name: 'AppStoreBase.collaborationTasks', context: context);

  @override
  ObservableList<TaskModel> get collaborationTasks {
    _$collaborationTasksAtom.reportRead();
    return super.collaborationTasks;
  }

  @override
  set collaborationTasks(ObservableList<TaskModel> value) {
    _$collaborationTasksAtom.reportWrite(value, super.collaborationTasks, () {
      super.collaborationTasks = value;
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
  UserModel get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(UserModel value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$selectedDateAtom =
      Atom(name: 'AppStoreBase.selectedDate', context: context);

  @override
  DateTime get selectedDate {
    _$selectedDateAtom.reportRead();
    return super.selectedDate;
  }

  @override
  set selectedDate(DateTime value) {
    _$selectedDateAtom.reportWrite(value, super.selectedDate, () {
      super.selectedDate = value;
    });
  }

  late final _$setUserAsyncAction =
      AsyncAction('AppStoreBase.setUser', context: context);

  @override
  Future<dynamic> setUser(String id) {
    return _$setUserAsyncAction.run(() => super.setUser(id));
  }

  late final _$AppStoreBaseActionController =
      ActionController(name: 'AppStoreBase', context: context);

  @override
  void fetchCollaborationTasks(String id) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.fetchCollaborationTasks');
    try {
      return super.fetchCollaborationTasks(id);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fetchTasks(String id) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.fetchTasks');
    try {
      return super.fetchTasks(id);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void fetchBoards(String id) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.fetchBoards');
    try {
      return super.fetchBoards(id);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initState(String id) {
    final _$actionInfo = _$AppStoreBaseActionController.startAction(
        name: 'AppStoreBase.initState');
    try {
      return super.initState(id);
    } finally {
      _$AppStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
ownTasks: ${ownTasks},
collaborationTasks: ${collaborationTasks},
boards: ${boards},
user: ${user},
selectedDate: ${selectedDate},
tasks: ${tasks},
todayTasks: ${todayTasks},
listArchiveTasks: ${listArchiveTasks},
listAllTask: ${listAllTask},
listActiveTask: ${listActiveTask},
listCollaborationTask: ${listCollaborationTask},
listAllCollaborationTask: ${listAllCollaborationTask},
nextTasks: ${nextTasks}
    ''';
  }
}

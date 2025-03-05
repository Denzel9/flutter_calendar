// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on AppStoreBase, Store {
  Computed<List<TaskModel>>? _$todayTasksComputed;

  @override
  List<TaskModel> get todayTasks => (_$todayTasksComputed ??=
          Computed<List<TaskModel>>(() => super.todayTasks,
              name: 'AppStoreBase.todayTasks'))
      .value;
  Computed<List<TaskModel>>? _$listClosedTasksComputed;

  @override
  List<TaskModel> get listClosedTasks => (_$listClosedTasksComputed ??=
          Computed<List<TaskModel>>(() => super.listClosedTasks,
              name: 'AppStoreBase.listClosedTasks'))
      .value;
  Computed<List<TaskModel>>? _$listAllTaskComputed;

  @override
  List<TaskModel> get listAllTask => (_$listAllTaskComputed ??=
          Computed<List<TaskModel>>(() => super.listAllTask,
              name: 'AppStoreBase.listAllTask'))
      .value;
  Computed<List<TaskModel>>? _$listOpenedTaskComputed;

  @override
  List<TaskModel> get listOpenedTask => (_$listOpenedTaskComputed ??=
          Computed<List<TaskModel>>(() => super.listOpenedTask,
              name: 'AppStoreBase.listOpenedTask'))
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

  late final _$tasksAtom = Atom(name: 'AppStoreBase.tasks', context: context);

  @override
  ObservableList<TaskModel> get tasks {
    _$tasksAtom.reportRead();
    return super.tasks;
  }

  @override
  set tasks(ObservableList<TaskModel> value) {
    _$tasksAtom.reportWrite(value, super.tasks, () {
      super.tasks = value;
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
  Future<void> setUser(String id) {
    return _$setUserAsyncAction.run(() => super.setUser(id));
  }

  late final _$fetchCollaborationTasksAsyncAction =
      AsyncAction('AppStoreBase.fetchCollaborationTasks', context: context);

  @override
  Future<void> fetchCollaborationTasks(String id) {
    return _$fetchCollaborationTasksAsyncAction
        .run(() => super.fetchCollaborationTasks(id));
  }

  late final _$fetchTasksAsyncAction =
      AsyncAction('AppStoreBase.fetchTasks', context: context);

  @override
  Future<void> fetchTasks(String id) {
    return _$fetchTasksAsyncAction.run(() => super.fetchTasks(id));
  }

  late final _$fetchBoardsAsyncAction =
      AsyncAction('AppStoreBase.fetchBoards', context: context);

  @override
  Future<void> fetchBoards(String id) {
    return _$fetchBoardsAsyncAction.run(() => super.fetchBoards(id));
  }

  late final _$initStateAsyncAction =
      AsyncAction('AppStoreBase.initState', context: context);

  @override
  Future<void> initState(String id) {
    return _$initStateAsyncAction.run(() => super.initState(id));
  }

  @override
  String toString() {
    return '''
tasks: ${tasks},
collaborationTasks: ${collaborationTasks},
boards: ${boards},
user: ${user},
selectedDate: ${selectedDate},
todayTasks: ${todayTasks},
listClosedTasks: ${listClosedTasks},
listAllTask: ${listAllTask},
listOpenedTask: ${listOpenedTask},
listCollaborationTask: ${listCollaborationTask},
listAllCollaborationTask: ${listAllCollaborationTask}
    ''';
  }
}

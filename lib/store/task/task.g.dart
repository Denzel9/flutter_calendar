// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TaskStore on XStore, Store {
  Computed<List<Task>>? _$listAllTaskComputed;

  @override
  List<Task> get listAllTask =>
      (_$listAllTaskComputed ??= Computed<List<Task>>(() => super.listAllTask,
              name: 'XStore.listAllTask'))
          .value;
  Computed<List<Task>>? _$listActiveTaskComputed;

  @override
  List<Task> get listActiveTask => (_$listActiveTaskComputed ??=
          Computed<List<Task>>(() => super.listActiveTask,
              name: 'XStore.listActiveTask'))
      .value;

  late final _$tasksAtom = Atom(name: 'XStore.tasks', context: context);

  @override
  List<Task> get tasks {
    _$tasksAtom.reportRead();
    return super.tasks;
  }

  @override
  set tasks(List<Task> value) {
    _$tasksAtom.reportWrite(value, super.tasks, () {
      super.tasks = value;
    });
  }

  late final _$titleAtom = Atom(name: 'XStore.title', context: context);

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  late final _$descriptionAtom =
      Atom(name: 'XStore.description', context: context);

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$isAllTaskAtom = Atom(name: 'XStore.isAllTask', context: context);

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
      Atom(name: 'XStore.isActiveTask', context: context);

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

  late final _$getTasksAsyncAction =
      AsyncAction('XStore.getTasks', context: context);

  @override
  Future<dynamic> getTasks() {
    return _$getTasksAsyncAction.run(() => super.getTasks());
  }

  late final _$XStoreActionController =
      ActionController(name: 'XStore', context: context);

  @override
  void addTask(List<Task> listTask) {
    final _$actionInfo =
        _$XStoreActionController.startAction(name: 'XStore.addTask');
    try {
      return super.addTask(listTask);
    } finally {
      _$XStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tasks: ${tasks},
title: ${title},
description: ${description},
isAllTask: ${isAllTask},
isActiveTask: ${isActiveTask},
listAllTask: ${listAllTask},
listActiveTask: ${listActiveTask}
    ''';
  }
}

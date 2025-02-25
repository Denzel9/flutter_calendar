// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStoreLocal on XStore, Store {
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

  late final _$isCollaborationTasksAtom =
      Atom(name: 'XStore.isCollaborationTasks', context: context);

  @override
  bool get isCollaborationTasks {
    _$isCollaborationTasksAtom.reportRead();
    return super.isCollaborationTasks;
  }

  @override
  set isCollaborationTasks(bool value) {
    _$isCollaborationTasksAtom.reportWrite(value, super.isCollaborationTasks,
        () {
      super.isCollaborationTasks = value;
    });
  }

  late final _$tabIndexAtom = Atom(name: 'XStore.tabIndex', context: context);

  @override
  int get tabIndex {
    _$tabIndexAtom.reportRead();
    return super.tabIndex;
  }

  @override
  set tabIndex(int value) {
    _$tabIndexAtom.reportWrite(value, super.tabIndex, () {
      super.tabIndex = value;
    });
  }

  @override
  String toString() {
    return '''
isActiveTask: ${isActiveTask},
isCollaborationTasks: ${isCollaborationTasks},
tabIndex: ${tabIndex}
    ''';
  }
}

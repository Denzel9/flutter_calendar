// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TaskStoreLocal on XStore, Store {
  late final _$currentBoardAtom =
      Atom(name: 'XStore.currentBoard', context: context);

  @override
  String get currentBoard {
    _$currentBoardAtom.reportRead();
    return super.currentBoard;
  }

  @override
  set currentBoard(String value) {
    _$currentBoardAtom.reportWrite(value, super.currentBoard, () {
      super.currentBoard = value;
    });
  }

  late final _$isEditAtom = Atom(name: 'XStore.isEdit', context: context);

  @override
  bool get isEdit {
    _$isEditAtom.reportRead();
    return super.isEdit;
  }

  @override
  set isEdit(bool value) {
    _$isEditAtom.reportWrite(value, super.isEdit, () {
      super.isEdit = value;
    });
  }

  late final _$isDoneTaskAtom =
      Atom(name: 'XStore.isDoneTask', context: context);

  @override
  bool get isDoneTask {
    _$isDoneTaskAtom.reportRead();
    return super.isDoneTask;
  }

  @override
  set isDoneTask(bool value) {
    _$isDoneTaskAtom.reportWrite(value, super.isDoneTask, () {
      super.isDoneTask = value;
    });
  }

  late final _$imageAtom = Atom(name: 'XStore.image', context: context);

  @override
  List<File> get image {
    _$imageAtom.reportRead();
    return super.image;
  }

  @override
  set image(List<File> value) {
    _$imageAtom.reportWrite(value, super.image, () {
      super.image = value;
    });
  }

  @override
  String toString() {
    return '''
currentBoard: ${currentBoard},
isEdit: ${isEdit},
isDoneTask: ${isDoneTask},
image: ${image}
    ''';
  }
}

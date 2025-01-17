// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CreateStoreLocal on XStore, Store {
  late final _$boardsAtom = Atom(name: 'XStore.boards', context: context);

  @override
  List<String> get boards {
    _$boardsAtom.reportRead();
    return super.boards;
  }

  @override
  set boards(List<String> value) {
    _$boardsAtom.reportWrite(value, super.boards, () {
      super.boards = value;
    });
  }

  late final _$assignAtom = Atom(name: 'XStore.assign', context: context);

  @override
  List<String> get assign {
    _$assignAtom.reportRead();
    return super.assign;
  }

  @override
  set assign(List<String> value) {
    _$assignAtom.reportWrite(value, super.assign, () {
      super.assign = value;
    });
  }

  late final _$boardAtom = Atom(name: 'XStore.board', context: context);

  @override
  String get board {
    _$boardAtom.reportRead();
    return super.board;
  }

  @override
  set board(String value) {
    _$boardAtom.reportWrite(value, super.board, () {
      super.board = value;
    });
  }

  late final _$taskTitleAtom = Atom(name: 'XStore.taskTitle', context: context);

  @override
  String get taskTitle {
    _$taskTitleAtom.reportRead();
    return super.taskTitle;
  }

  @override
  set taskTitle(String value) {
    _$taskTitleAtom.reportWrite(value, super.taskTitle, () {
      super.taskTitle = value;
    });
  }

  late final _$taskDescriptionAtom =
      Atom(name: 'XStore.taskDescription', context: context);

  @override
  String get taskDescription {
    _$taskDescriptionAtom.reportRead();
    return super.taskDescription;
  }

  @override
  set taskDescription(String value) {
    _$taskDescriptionAtom.reportWrite(value, super.taskDescription, () {
      super.taskDescription = value;
    });
  }

  late final _$boardTitleAtom =
      Atom(name: 'XStore.boardTitle', context: context);

  @override
  String get boardTitle {
    _$boardTitleAtom.reportRead();
    return super.boardTitle;
  }

  @override
  set boardTitle(String value) {
    _$boardTitleAtom.reportWrite(value, super.boardTitle, () {
      super.boardTitle = value;
    });
  }

  late final _$boardDescriptionAtom =
      Atom(name: 'XStore.boardDescription', context: context);

  @override
  String get boardDescription {
    _$boardDescriptionAtom.reportRead();
    return super.boardDescription;
  }

  @override
  set boardDescription(String value) {
    _$boardDescriptionAtom.reportWrite(value, super.boardDescription, () {
      super.boardDescription = value;
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
boards: ${boards},
assign: ${assign},
board: ${board},
taskTitle: ${taskTitle},
taskDescription: ${taskDescription},
boardTitle: ${boardTitle},
boardDescription: ${boardDescription},
isEdit: ${isEdit},
image: ${image}
    ''';
  }
}

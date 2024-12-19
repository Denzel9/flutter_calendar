// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BoardStore on XStore, Store {
  late final _$boardAtom = Atom(name: 'XStore.board', context: context);

  @override
  List<Board> get board {
    _$boardAtom.reportRead();
    return super.board;
  }

  @override
  set board(List<Board> value) {
    _$boardAtom.reportWrite(value, super.board, () {
      super.board = value;
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

  late final _$addBoardAsyncAction =
      AsyncAction('XStore.addBoard', context: context);

  @override
  Future<dynamic> addBoard(List<Board> newBoards) {
    return _$addBoardAsyncAction.run(() => super.addBoard(newBoards));
  }

  @override
  String toString() {
    return '''
board: ${board},
title: ${title},
description: ${description}
    ''';
  }
}

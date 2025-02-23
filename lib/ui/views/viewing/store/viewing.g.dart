// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viewing.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ViewingStoreLocal on XStore, Store {
  late final _$selectedDateAtom =
      Atom(name: 'XStore.selectedDate', context: context);

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

  late final _$currentMonthIndexAtom =
      Atom(name: 'XStore.currentMonthIndex', context: context);

  @override
  int get currentMonthIndex {
    _$currentMonthIndexAtom.reportRead();
    return super.currentMonthIndex;
  }

  @override
  set currentMonthIndex(int value) {
    _$currentMonthIndexAtom.reportWrite(value, super.currentMonthIndex, () {
      super.currentMonthIndex = value;
    });
  }

  late final _$isShowSearchAtom =
      Atom(name: 'XStore.isShowSearch', context: context);

  @override
  bool get isShowSearch {
    _$isShowSearchAtom.reportRead();
    return super.isShowSearch;
  }

  @override
  set isShowSearch(bool value) {
    _$isShowSearchAtom.reportWrite(value, super.isShowSearch, () {
      super.isShowSearch = value;
    });
  }

  late final _$isOpenCalendarAtom =
      Atom(name: 'XStore.isOpenCalendar', context: context);

  @override
  bool get isOpenCalendar {
    _$isOpenCalendarAtom.reportRead();
    return super.isOpenCalendar;
  }

  @override
  set isOpenCalendar(bool value) {
    _$isOpenCalendarAtom.reportWrite(value, super.isOpenCalendar, () {
      super.isOpenCalendar = value;
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

  late final _$isCollaborationAtom =
      Atom(name: 'XStore.isCollaboration', context: context);

  @override
  bool get isCollaboration {
    _$isCollaborationAtom.reportRead();
    return super.isCollaboration;
  }

  @override
  set isCollaboration(bool value) {
    _$isCollaborationAtom.reportWrite(value, super.isCollaboration, () {
      super.isCollaboration = value;
    });
  }

  late final _$searchtextAtom =
      Atom(name: 'XStore.searchtext', context: context);

  @override
  String get searchtext {
    _$searchtextAtom.reportRead();
    return super.searchtext;
  }

  @override
  set searchtext(String value) {
    _$searchtextAtom.reportWrite(value, super.searchtext, () {
      super.searchtext = value;
    });
  }

  @override
  String toString() {
    return '''
selectedDate: ${selectedDate},
currentMonthIndex: ${currentMonthIndex},
isShowSearch: ${isShowSearch},
isOpenCalendar: ${isOpenCalendar},
isAllTask: ${isAllTask},
isActiveTask: ${isActiveTask},
isCollaboration: ${isCollaboration},
searchtext: ${searchtext}
    ''';
  }
}

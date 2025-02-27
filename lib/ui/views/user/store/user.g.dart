// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStoreLocal on XStore, Store {
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

  late final _$userAtom = Atom(name: 'XStore.user', context: context);

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

  late final _$imageAtom = Atom(name: 'XStore.image', context: context);

  @override
  File? get image {
    _$imageAtom.reportRead();
    return super.image;
  }

  @override
  set image(File? value) {
    _$imageAtom.reportWrite(value, super.image, () {
      super.image = value;
    });
  }

  late final _$isGuestAtom = Atom(name: 'XStore.isGuest', context: context);

  @override
  bool get isGuest {
    _$isGuestAtom.reportRead();
    return super.isGuest;
  }

  @override
  set isGuest(bool value) {
    _$isGuestAtom.reportWrite(value, super.isGuest, () {
      super.isGuest = value;
    });
  }

  late final _$attachmentsCountAtom =
      Atom(name: 'XStore.attachmentsCount', context: context);

  @override
  int get attachmentsCount {
    _$attachmentsCountAtom.reportRead();
    return super.attachmentsCount;
  }

  @override
  set attachmentsCount(int value) {
    _$attachmentsCountAtom.reportWrite(value, super.attachmentsCount, () {
      super.attachmentsCount = value;
    });
  }

  late final _$collaborationUserIdsAtom =
      Atom(name: 'XStore.collaborationUserIds', context: context);

  @override
  List<String?> get collaborationUserIds {
    _$collaborationUserIdsAtom.reportRead();
    return super.collaborationUserIds;
  }

  @override
  set collaborationUserIds(List<String?> value) {
    _$collaborationUserIdsAtom.reportWrite(value, super.collaborationUserIds,
        () {
      super.collaborationUserIds = value;
    });
  }

  late final _$getUserAsyncAction =
      AsyncAction('XStore.getUser', context: context);

  @override
  Future<Null> getUser(String id) {
    return _$getUserAsyncAction.run(() => super.getUser(id));
  }

  late final _$resetAsyncAction = AsyncAction('XStore.reset', context: context);

  @override
  Future<Null> reset() {
    return _$resetAsyncAction.run(() => super.reset());
  }

  @override
  String toString() {
    return '''
isEdit: ${isEdit},
user: ${user},
image: ${image},
isGuest: ${isGuest},
attachmentsCount: ${attachmentsCount},
collaborationUserIds: ${collaborationUserIds}
    ''';
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserStore on XStore, Store {
  late final _$userAtom = Atom(name: 'XStore.user', context: context);

  @override
  User get user {
    _$userAtom.reportRead();
    return super.user;
  }

  @override
  set user(User value) {
    _$userAtom.reportWrite(value, super.user, () {
      super.user = value;
    });
  }

  late final _$setUserAsyncAction =
      AsyncAction('XStore.setUser', context: context);

  @override
  Future setUser(String id) {
    return _$setUserAsyncAction.run(() => super.setUser(id));
  }

  @override
  String toString() {
    return '''
user: ${user}
    ''';
  }
}

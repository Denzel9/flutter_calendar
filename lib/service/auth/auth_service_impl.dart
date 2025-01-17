import 'package:calendar_flutter/service/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/controller/firebase.dart';

class AuthServiceImpl implements AuthService {
  @override
  bool isLoading = false;

  @override
  Future<User> register(String login, String password) async {
    isLoading = true;
    final credential = await auth.createUserWithEmailAndPassword(
        email: login, password: password);
    final User user = credential.user!;
    return user;
  }

  @override
  Future<User> login(String login, String password) async {
    isLoading = true;
    final credential =
        await auth.signInWithEmailAndPassword(email: login, password: password);
    final User user = credential.user!;
    return user;
  }
}

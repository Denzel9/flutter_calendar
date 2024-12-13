import 'package:calendar_flutter/service/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceImpl implements AuthService {
  @override
  Future<User> register(String login, String password) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: login, password: password);
    final User user = credential.user!;
    return user;
  }

  @override
  Future<User> login(String login, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: login, password: password);
    final User user = credential.user!;
    return user;
  }
}

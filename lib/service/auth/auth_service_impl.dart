import 'package:calendar_flutter/service/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/controller/controller.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseFirestore firestore;

  AuthServiceImpl(this.firestore);

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

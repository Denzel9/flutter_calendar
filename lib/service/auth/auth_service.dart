import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthService {
  bool isLoading = false;
  Future<User> register(String login, String password);
  Future<User> login(String login, String password);
}

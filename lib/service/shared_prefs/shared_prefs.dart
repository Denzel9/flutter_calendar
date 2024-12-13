import 'package:localstorage/localstorage.dart';

class LocalStorage {
  Future<String> getItem(String key) async {
    return localStorage.getItem(key) ?? '';
  }

  Future setItem(String key, String value) async {
    return localStorage.setItem(key, value);
  }

  Future deleteItem(
    String key,
  ) async {
    return localStorage.removeItem(key);
  }
}

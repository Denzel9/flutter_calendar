import 'package:calendar_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

List<User?>? searchUser(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? snapshot,
    TextEditingController controller) {
  final lowerCaseText = controller.text.toLowerCase();

  return snapshot
      ?.map((user) {
        final data = user.data();
        if (lowerCaseText.length > 2) {
          if (data['name'].toString().toLowerCase().contains(lowerCaseText) ||
              data['lastName']
                  .toString()
                  .toLowerCase()
                  .contains(lowerCaseText) ||
              data['email'].toString().toLowerCase().contains(lowerCaseText)) {
            return User.fromJsonWithId(user.data(), user.id);
          } else {
            return null;
          }
        } else {
          return null;
        }
      })
      .where((el) => el != null)
      .toList();
}

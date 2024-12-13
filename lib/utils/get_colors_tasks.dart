import 'package:flutter/material.dart';

Color getColorTasks(String board) {
  if (board == "Default") {
    return Colors.amber;
  }
  if (board == "Learning") {
    return Colors.blue;
  }
  if (board == "Work") {
    return Colors.red;
  }
  if (board == "Myself") {
    return Colors.green;
  }
  return Colors.transparent;
}

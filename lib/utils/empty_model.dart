import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/user.dart';

final emptyBoard = Board(
  author: '',
  title: '',
  description: '',
  userId: '',
  createdAt: '',
  tasks: [],
);

final emptyUser = UserModel(
  name: '',
  lastName: '',
  email: '',
  following: [],
  followers: [],
  docId: '',
);

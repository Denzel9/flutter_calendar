import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/utils/date.dart';

final task = TaskModel(
  author: 'author',
  done: false,
  board: 'board',
  title: 'title',
  description: 'description',
  assign: [],
  date: 'date',
  createdAt: 'createdAt',
  isCollaborated: false,
  userId: 'userId',
);

final collaborationTask = TaskModel(
  author: 'author',
  done: false,
  board: 'board',
  title: 'title',
  description: 'description',
  assign: ['userId'],
  date: now.toString(),
  createdAt: 'createdAt',
  isCollaborated: true,
  userId: 'anotherUserId',
);

final board = Board(
  author: 'author',
  title: 'title',
  description: 'description',
  userId: 'userId',
  createdAt: 'createdAt',
  tasks: [],
);

import 'package:calendar_flutter/service/auth/auth_service_impl.dart';
import 'package:calendar_flutter/service/board/board_service_impl.dart';
import 'package:calendar_flutter/service/local_storage/local_storage.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
final LocalStorage localStorage = LocalStorage();

final TaskServiceImpl taskService = TaskServiceImpl(firestore);
final BoardServiceImpl boardService = BoardServiceImpl(firestore);
final UserServiceImpl userService = UserServiceImpl(firestore);
final AuthServiceImpl authService = AuthServiceImpl(firestore);

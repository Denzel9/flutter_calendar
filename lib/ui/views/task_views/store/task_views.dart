import 'package:calendar_flutter/utils/date.dart';
import 'package:mobx/mobx.dart';

part 'task_views.g.dart';

class TaskViewsStoreLocal = XStore with _$TaskViewsStoreLocal;

abstract class XStore with Store {
  @observable
  DateTime selectedDate = now;

  @observable
  int currentMonthIndex = now.month - 1;

  @observable
  bool isShowSearch = false;

  @observable
  bool isOpenCalendar = false;
}

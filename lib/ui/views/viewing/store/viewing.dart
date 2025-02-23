import 'package:calendar_flutter/utils/date.dart';
import 'package:mobx/mobx.dart';

part 'viewing.g.dart';

class ViewingStoreLocal = XStore with _$ViewingStoreLocal;

abstract class XStore with Store {
  @observable
  DateTime selectedDate = now;

  @observable
  int currentMonthIndex = now.month - 1;

  @observable
  bool isShowSearch = false;

  @observable
  bool isOpenCalendar = false;

  @observable
  bool isAllTask = false;

  @observable
  bool isActiveTask = true;

  @observable
  bool isCollaboration = false;

  @observable
  String searchtext = '';
}

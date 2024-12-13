import 'package:calendar_flutter/models/board.dart';
import 'package:calendar_flutter/models/task.dart';
import 'package:calendar_flutter/models/user.dart';
import 'package:calendar_flutter/service/task/task_service_impl.dart';
import 'package:calendar_flutter/service/user/user_service_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

part 'store.g.dart';

TaskServiceImpl taskService = TaskServiceImpl();
UserServiceImpl userService = UserServiceImpl();

class AppStore = AppStoreBase with _$AppStore;

abstract class AppStoreBase with Store {
  @observable
  ObservableList<Task> tasks = ObservableList<Task>.of([]);

  @observable
  ObservableList<Board> boards = ObservableList<Board>.of([]);

  @observable
  User? user;

  // @computed
  // List<Product> get filteredProducts {
  //   if (searchKeyword.isNotEmpty) {
  //     return ObservableList.of(
  //       products.where((Product product) {
  //         String productName = product.name.toLowerCase();
  //         bool inProductName = productName.contains(searchKeyword);
  //         return inProductName;
  //       }).toList(),
  //     );
  //   } else {
  //     return products;
  //   }
  // }

  @action
  setUser(String id) async {
    userService.setUser(id).then((response) => user = response);
  }

  @action
  void initState() {
    fetchTasks();
    // fetchCategories().then(
    //   (_) {
    //     fetchProducts(categories.first.uid);
    //     currentlySelectedCategory = categories.first;
    //   },
    // );
    // fetchHotItmes();
  }

  @action
  Future<Null> fetchTasks() async {
    QuerySnapshot query = await taskService.getTasks();
    tasks = ObservableList.of(
      query.docs
          .map((DocumentSnapshot doc) =>
              Task.fromJsonWithId(doc.data() as Map<String, dynamic>?, doc.id))
          .toList(),
    );
  }

  @observable
  bool isAllTask = false;

  @observable
  bool isActiveTask = false;

  @computed
  List<Task> get listAllTask => tasks;

  @computed
  List<Task> get listActiveTask => tasks.where((task) => task.done).toList();

  // @action
  // Future<Null> fetchProducts(String categoryUid) async {
  //   QuerySnapshot query = await _api.fetchProducts(categoryUid);
  //   products = ObservableList.of(
  //     query.documents
  //         .map((DocumentSnapshot doc) => Product.fromJson(doc.data))
  //         .toList(),
  //   );
  // }

  // @action
  // Future<Null> fetchHotItmes() async {
  //   QuerySnapshot query = await _api.fetchHotItems();
  //   hotItems = ObservableList.of(
  //     query.documents
  //         .map((DocumentSnapshot doc) => Product.fromJson(doc.data))
  //         .toList(),
  //   );
  // }

  // @action
  // void changeCategory(Category category) {
  //   currentlySelectedCategory = category;
  //   fetchProducts(category.uid);
  // }

  // @action
  // void setSearchKeyword(String keyword) {
  //   searchKeyword = keyword.toLowerCase();
  // }
}

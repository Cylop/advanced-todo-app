import 'package:advanced_todo/database/abstract_database.dart';
import 'package:advanced_todo/database/model/todo/home_todo_item_wrapper.dart';
import 'package:advanced_todo/database/model/todo/todo_item_model.dart';
import 'package:advanced_todo/database/model/todo/todo_list_model.dart';
import 'package:advanced_todo/database/model/todo/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import '../../extension.dart';

class TodoDatabase extends AbstractDatabase {
  static const String LIST_COLLECTION = 'todo_lists';
  static const String TODO_COLLECTION = 'todo_items';
  static const String QUICK_NOTES = 'quick_note_items';

  TodoDatabase(User user) : super(user);

  Future<Map<DateTime, List<TodoItemModel>>> getTodosGroupByDate(DateTime startDate, DateTime endDate) async {
    QuerySnapshot snapshot = await this.getDatabase.collection(TODO_COLLECTION)
      .where('dueToDay', isGreaterThanOrEqualTo: startDate)
      .where('dueToDay', isLessThanOrEqualTo: endDate)
      //.where('isDone', isEqualTo: false)
      //.where('uid', isEqualTo: user.uid).get();
    .get();
    List<TodoItemModel> items = snapshot.docs.map((e) => TodoItemModel.fromFirebase(e)).toList();
    return items.groupBy((item) => item.dueToDay.toDate());
  }

  Stream<List<AbstractTodoModel>> _getMergedTodoListItems(
      Stream<List<TodoListModel>> lists, Stream<List<TodoItemModel>> todos, {bool onlyOpen = true}) {
    return Rx.combineLatest2(lists, todos,
        (List<TodoListModel> todoLists, List<TodoItemModel> todoItems) {
      final List<AbstractTodoModel> merged = [];
      todoLists
          .where((_list) =>
              todoItems
                  .where((_item) => _item.listId == _list.id && (onlyOpen ? !_item.isDone : true))
                  .length !=
              0)
          .forEach((_list) {
        merged.add(_list);
        List todos = todoItems
            .where((_item) => _item.listId == _list.id && (onlyOpen ? !_item.isDone : true))
            .toList();

        todos.forEach((_item) => merged.add(HomeTodoItemWrapper(
            _item, todos.indexOf(_item) == todos.length - 1)));
      });
      return merged;
    });
  }

  Stream<List<AbstractTodoModel>> getMergedTodoListItemsDueToDate(DateTime dateTime, {bool onlyOpen = false}) {
    return this._getMergedTodoListItems(
        this.getLists(limit: 50), this.getTodosDueToDate(dateTime), onlyOpen: onlyOpen);
  }

  ///Get all Todolists merged with todos for Homescreen.
  ///It's simpler to show items due to today with that way.
  Stream<List<AbstractTodoModel>> getMergedTodoListItemsOverdue() {
    return this._getMergedTodoListItems(
        this.getLists(limit: 50), this.getTodosDueBefore());
  }

  Stream<List<AbstractTodoModel>> getMergedTodoListItemsDueToToday() {
    return this._getMergedTodoListItems(
        this.getLists(limit: 50), this.getTodosDueToday());
  }

  Future<void> toggleIsDoneOfTodo(TodoItemModel todoItem) {
    todoItem.isDone = !todoItem.isDone;
    return this
        .getDatabase
        .collection(TODO_COLLECTION)
        .doc(todoItem.id)
        .set(todoItem.toMap());
  }

  Stream<List<TodoItemModel>> getTodosDueToDate(DateTime dateTime) {
    DateTime todayEarly = DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0, 0);
    DateTime todayLate = DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59);
    return this
        .getDatabase
        .collection(TODO_COLLECTION)
        .where(
      'dueTo',
      isGreaterThanOrEqualTo: Timestamp.fromDate(todayEarly),
    )
        .where(
      'dueTo',
      isLessThanOrEqualTo: Timestamp.fromDate(todayLate),
    )
        .orderBy('dueTo')
        .snapshots()
        .map((event) =>
        event.docs.map((e) => TodoItemModel.fromFirebase(e)).toList());
  }

  Stream<List<TodoItemModel>> getTodosDueToday() {
    DateTime now = DateTime.now();
    DateTime todayEarly = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime todayLate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return this
        .getDatabase
        .collection(TODO_COLLECTION)
        .where(
      'dueTo',
      isGreaterThanOrEqualTo: Timestamp.fromDate(todayEarly),
    )
        .where(
      'dueTo',
      isLessThanOrEqualTo: Timestamp.fromDate(todayLate),
    )
        .orderBy('dueTo')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => TodoItemModel.fromFirebase(e)).toList());
  }

  Stream<List<TodoItemModel>> getTodosDueBefore() {
    DateTime now = Timestamp.now().toDate();
    DateTime todayEarly = DateTime(now.year, now.month, now.day, 0, 0, 0);
    return this
        .getDatabase
        .collection(TODO_COLLECTION)
        .where('dueTo', isLessThan: Timestamp.fromDate(todayEarly))
        .orderBy('dueTo')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => TodoItemModel.fromFirebase(e)).toList());
  }

  static bool isDueToday(Timestamp timestamp) {
    if (timestamp == null) return false;
    final DateTime now = Timestamp.now().toDate();
    final DateTime timeStampDate = timestamp.toDate();
    return timeStampDate.year == now.year &&
        timeStampDate.month == now.month &&
        timeStampDate.day == now.day;
  }

  static bool isOverDue(Timestamp timestamp) {
    if (timestamp == null) return false;
    final DateTime now = Timestamp.now().toDate();
    final DateTime today = DateTime(now.year, now.month, now.day, 0, 0);
    final DateTime timeStampDate = timestamp.toDate();
    return today.isAfter(timeStampDate);
  }

  /// Get todo_lists by specific Owner uid
  Stream<List<TodoListModel>> getLists({limit: 5}) {
    return this
        .getDatabase
        .collection(LIST_COLLECTION)
        .where('createdBy', isEqualTo: this.user.uid)
        .limit(limit)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => TodoListModel.fromFirestore(e)).toList());
  }

  ///Get all todo_items by specific list
  Stream<List<TodoItemModel>> getTodosByList(String listUid) {
    return this
        .getDatabase
        .collection(TODO_COLLECTION)
        .where('listId', isEqualTo: listUid)
        .snapshots()
        .map((item) =>
            item.docs.map((e) => TodoItemModel.fromFirebase(e)).toList());
  }

  TodoListModel createTodoListWithArgs(String title, String description) {
    return TodoListModel(
        title: title,
        description: description,
        createdAt: Timestamp.now(),
        createdBy: this.user.uid);
  }

  TodoItemModel createTodoItemWithArgs(
      String title, String description, DateTime dueTo) {
    return TodoItemModel(
        title: title,
        description: description,
        createdAt: Timestamp.now(),
        dueTo: dueTo != null ? Timestamp.fromDate(dueTo) : null,
        createdBy: this.user.uid);
  }

  Future<DocumentReference> createTodoList(TodoListModel todoList) async {
    return this.getDatabase.collection(LIST_COLLECTION).add(todoList.toMap());
  }

  Future<DocumentReference> createTodoItem(
      String listId, TodoItemModel itemModel) {
    Map<String, dynamic> itemMap = itemModel.toMap();
    DateTime dueTo = itemModel.dueTo.toDate();
    DateTime dueToDay = DateTime(
      dueTo.year,
      dueTo.month,
      dueTo.day,
      0,
      0,
      0,
    );
    itemMap.update('listId', (_) => listId);
    itemMap.update('dueToDay', (_) => Timestamp.fromDate(dueToDay));
    return this.getDatabase.collection(TODO_COLLECTION).add(itemMap);
  }

  Future<DocumentReference> insertList() async {
    return createTodoList(new TodoListModel(
      createdBy: 'fHuugjDyYjbS5MZ8TfC2Jm3KAwC2',
      createdAt: Timestamp.now(),
      title: 'Mein Titel!',
      description: 'Meien wunderschöne description hihihi',
    ));
  }
}

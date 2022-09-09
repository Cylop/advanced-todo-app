import 'package:advanced_todo/database/model/todo/todo_item_model.dart';
import 'package:advanced_todo/database/model/todo/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeTodoItemWrapper extends AbstractTodoModel{

  final TodoItemModel _todoItemModel;
  final bool last;

  HomeTodoItemWrapper(this._todoItemModel, this.last);

  @override
  Timestamp get getCreatedAt => this._todoItemModel.createdAt;

  @override
  String get getCreatedBy => this._todoItemModel.createdBy;

  @override
  String get getDescription => this._todoItemModel.description;

  @override
  String get getId => this._todoItemModel.id;

  @override
  String get getTitle => this._todoItemModel.title;

  TodoItemModel get getTodoItemModel => this._todoItemModel;

  bool get isLast => this.last;
}
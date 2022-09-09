import 'package:advanced_todo/database/model/todo/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItemModel extends AbstractTodoModel {
  final String id;
  final String listId;
  final String title;
  final String description;
  final String assignedTo;
  final String createdBy;
  final Timestamp createdAt;
  final Timestamp dueTo;
  final Timestamp dueToDay;
  bool isDone;
  final Map<String, dynamic> attributes;

  TodoItemModel({
    this.id,
    this.listId,
    this.title,
    this.description,
    this.assignedTo,
    this.createdBy,
    this.createdAt,
    this.dueTo,
    this.dueToDay,
    this.isDone = false,
    this.attributes
  });

  factory TodoItemModel.fromFirebase(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    return TodoItemModel(
      id: snapshot.id ?? 'not existing',
      listId: data['listId'] ?? '',
      title: data['title'] ?? 'Unknown',
      description: data['description'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      dueTo: data['dueTo'],
      dueToDay: data['dueToDay'],
      isDone: data['isDone'],
      attributes: data['attributes'] ?? Map(),
    );
  }

  Map<String, dynamic> toMap() => {
    'listId': this.listId,
    'title': this.title,
    'description': this.description,
    'assignedTo': this.assignedTo,
    'createdBy': this.createdBy,
    'createdAt': this.createdAt,
    'dueTo': this.dueTo,
    'dueToDay': this.dueToDay,
    'isDone': this.isDone ?? 'false',
    'attributes': this.attributes,
  };

  @override
  String get getId => id;

  @override
  Timestamp get getCreatedAt => createdAt;

  @override
  String get getCreatedBy => createdBy;

  @override
  String get getDescription => description;

  @override
  String get getTitle => title;
}

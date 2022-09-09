import 'package:advanced_todo/database/model/todo/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListModel extends AbstractTodoModel{
  final String id;
  final String title;
  final String description;
  final Timestamp createdAt;
  final String createdBy;

  TodoListModel({this.id, this.title, this.description, this.createdAt, this.createdBy});

  factory TodoListModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    return TodoListModel(
      id: snapshot.id,
      title: data['title'] ?? 'Unknown',
      description: data['description'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'title': this.title,
    'description': this.description,
    'createdAt': this.createdAt,
    'createdBy': this.createdBy,
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
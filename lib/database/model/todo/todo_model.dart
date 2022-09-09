import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AbstractTodoModel {
  String get getId;
  String get getTitle;
  String get getDescription;
  Timestamp get getCreatedAt;
  String get getCreatedBy;
}
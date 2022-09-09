import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AbstractDatabase extends ChangeNotifier{

  final FirebaseFirestore _database = FirebaseFirestore.instance;

  final User user;

  AbstractDatabase(this.user);

  FirebaseFirestore get getDatabase => this._database;
}
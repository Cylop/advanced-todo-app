import 'package:flutter/material.dart';

class ATDrawerState extends ChangeNotifier {
  String _currentDrawerEntry = 'dashboard';

  String get getCurrentDrawerEntry => this._currentDrawerEntry;
  void setCurrentDrawerEntry(String list) {
    this._currentDrawerEntry = list;
    notifyListeners();
  }
}
import 'package:flutter/material.dart';

class CalendarState extends ChangeNotifier {

  DateTime _selectedDate = DateTime.now();

  get getSelectedDate => _selectedDate;
  set setSelectedDate(date) {
    _selectedDate = date;
    notifyListeners();
  }
}
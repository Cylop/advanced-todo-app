import 'package:advanced_todo/database/todo_database/todo_database.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../routes.dart';

class ATAddTodoItemScreen extends StatefulWidget {
  @override
  _ATAddTodoItemScreenScreenState createState() => _ATAddTodoItemScreenScreenState();
}

class _ATAddTodoItemScreenScreenState extends State<ATAddTodoItemScreen> {

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TodoDatabase _todoDatabase = Provider.of<TodoDatabase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Todo'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  labelText: 'Title',
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Please enter a Title';
                  }
                  if(value.length > 400) {
                    return 'Please shorten your title. < 400 chars';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  labelText: 'Description',
                ),
                maxLines: 5,
              ),
              DateTimePicker(
                controller: this._dateTimeController,
                type: DateTimePickerType.dateTimeSeparate,
                firstDate: DateTime.now(),
                lastDate: DateTime(
                  2100,
                ),
                use24HourFormat: true,
                dateLabelText: 'Date',
                timeLabelText: 'Time',
              ),
              RaisedButton(
                child: Row(
                  children: [
                    Icon(Icons.playlist_add),
                    SizedBox(width: 5),
                    Text('Add Todo'),
                  ],
                ),
                onPressed: () {
                  if(this._formKey.currentState.validate()) {
                    Routes.sailor.pop(_todoDatabase.createTodoItemWithArgs(
                        _titleController.value.text,
                        _descriptionController.value.text,
                        DateTime.tryParse(_dateTimeController.value.text),
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

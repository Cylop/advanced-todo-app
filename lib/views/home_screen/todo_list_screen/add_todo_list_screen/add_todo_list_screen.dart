import 'package:advanced_todo/database/todo_database/todo_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../routes.dart';

class ATAddTodoListScreen extends StatefulWidget {
  @override
  _ATAddTodoListScreenState createState() => _ATAddTodoListScreenState();
}

class _ATAddTodoListScreenState extends State<ATAddTodoListScreen> {

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TodoDatabase _todoDatabase = Provider.of<TodoDatabase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Todolist'),
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
                  hintText: 'My new List',
                  labelText: 'Title',
                ),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Please enter a Title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'List for useful things..',
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
              ),
              RaisedButton(
                child: Row(
                  children: [
                    Icon(Icons.playlist_add),
                    SizedBox(width: 5),
                    Text('Add List'),
                  ],
                ),
                onPressed: () {
                  if(this._formKey.currentState.validate()) {
                    Routes.sailor.pop(_todoDatabase.createTodoListWithArgs(
                        _titleController.value.text,
                        _descriptionController.value.text));
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

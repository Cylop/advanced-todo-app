import 'package:advanced_todo/database/model/todo/todo_list_model.dart';
import 'package:advanced_todo/database/todo_database/todo_database.dart';
import 'package:advanced_todo/widgets/drawer/drawer_widget.dart';
import 'package:advanced_todo/widgets/todo/card/todo_list/todo_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';

class ATTodoListScreen extends StatelessWidget {
  Future<void> _addNewList(BuildContext context) async {
    final TodoListModel list = await Routes.navigateToAddTodoList();

    if (list != null) {
      TodoDatabase _todoDatabase =
          Provider.of<TodoDatabase>(context, listen: false);
      DocumentReference reference = await _todoDatabase.createTodoList(list);
      DocumentSnapshot snapshot = await reference.get();
      if (snapshot.exists) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Successfully added new Todolist!',
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.greenAccent[400],
            ),
          );
      } else {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('There was an Error whilst adding a new Todolist.'),
              backgroundColor: Colors.red,
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(
            Icons.add,
            //color: Colors.black54,
            semanticLabel: 'Add List',
            size: 30,
          ),
          //backgroundColor: Colors.teal[200],
          //hoverColor: Colors.grey,
          onPressed: () async {
            await _addNewList(context);
          },
        ),
      ),
      drawer: ATDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Your Todolists'),
            floating: true,
            snap: true,
          ),
          ATTodoLists(),
        ],
      ),
    );
  }
}

import 'package:advanced_todo/database/model/todo/todo_item_model.dart';
import 'package:advanced_todo/database/model/todo/todo_list_model.dart';
import 'package:advanced_todo/database/todo_database/todo_database.dart';
import 'package:advanced_todo/routes.dart';
import 'package:advanced_todo/widgets/drawer/drawer_widget.dart';
import 'package:advanced_todo/widgets/todo/card/todo_item/todo_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ATTodoOverviewScreen extends StatelessWidget {
  final TodoListModel _todoListModel;

  ATTodoOverviewScreen(this._todoListModel) : assert(_todoListModel != null);

  Future<void> _addNewTodo(BuildContext context) async {
    final TodoItemModel todoItem = await Routes.navigateToAddTodoItemScreen();

    if (todoItem != null) {
      TodoDatabase _todoDatabase =
          Provider.of<TodoDatabase>(context, listen: false);
      DocumentReference reference =
          await _todoDatabase.createTodoItem(this._todoListModel.id, todoItem);
      DocumentSnapshot snapshot = await reference.get();
      if (snapshot.exists) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                'Successfully added new Todo!',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.teal[200],
            ),
          );
      } else {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('There was an Error whilst adding a new Todo.'),
              backgroundColor: Colors.red,
            ),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TodoDatabase _todoDatabase =
        Provider.of<TodoDatabase>(context, listen: false);
    return Scaffold(
      drawer: ATDrawer(),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          //backgroundColor: Colors.teal[200],
          onPressed: () async => await this._addNewTodo(context),
          child: Icon(Icons.post_add),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(this._todoListModel.title),
            floating: true,
            snap: true,
          ),
          StreamBuilder(
            stream: _todoDatabase.getTodosByList(this._todoListModel.id),
            builder: (BuildContext context,
                AsyncSnapshot<List<TodoItemModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'You currently dont have any Todos in this list. Go ahead and create one!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            ATTodoItem(snapshot.data[index]),
                          ],
                        ),
                      ),
                    ),
                  ),
                  childCount: snapshot.hasData ? snapshot.data.length : 0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

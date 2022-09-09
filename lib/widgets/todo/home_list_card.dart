import 'package:advanced_todo/database/model/todo/home_todo_item_wrapper.dart';
import 'package:advanced_todo/database/model/todo/todo_list_model.dart';
import 'package:advanced_todo/database/model/todo/todo_model.dart';
import 'package:advanced_todo/widgets/todo/card/todo_item/todo_item.dart';
import 'package:advanced_todo/widgets/todo/card/todo_list/todo_list_card_tile.dart';
import 'package:advanced_todo/widgets/todo/home_list_tile.dart';
import 'package:flutter/material.dart';

class ATHomeListCard extends StatelessWidget {
  final AbstractTodoModel _abstractTodo;

  const ATHomeListCard(this._abstractTodo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return this._buildTile();
  }

  Widget _buildTile() {
    if (_abstractTodo is TodoListModel) {
      return ATHomeListTile(
        isFirst: true,
        widget: ATTodoListCard(
          _abstractTodo as TodoListModel,
          homePage: true,
        ),
      );
    } else if (_abstractTodo is HomeTodoItemWrapper) {
      final HomeTodoItemWrapper wrapper = _abstractTodo as HomeTodoItemWrapper;
      return Padding(
        padding: wrapper.isLast ? const EdgeInsets.only(bottom: 15.0) : const EdgeInsets.only(bottom: .0),
        child: ATHomeListTile(
          isLast: wrapper.isLast,
          widget: ATTodoItem(
            wrapper.getTodoItemModel,
          ),
        ),
      );
    }

    return Text('something went wrong');
  }
}

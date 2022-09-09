import 'package:advanced_todo/database/model/todo/todo_item_model.dart';
import 'package:advanced_todo/database/todo_database/todo_database.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ATTodoItem extends StatelessWidget {
  final TodoItemModel _todoItemModel;

  ATTodoItem(this._todoItemModel) : assert(_todoItemModel != null);

  void _setIsDone(TodoDatabase todoDatabase, bool done) {
    todoDatabase.toggleIsDoneOfTodo(this._todoItemModel);
  }

  @override
  Widget build(BuildContext context) {
    final TodoDatabase _todoDatabase = Provider.of<TodoDatabase>(context, listen: false);

    final DateTime date = DateTime.fromMillisecondsSinceEpoch(
        this._todoItemModel.createdAt.millisecondsSinceEpoch);
    final String formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020
    return Expanded(
      child: Container(
        constraints: BoxConstraints(minHeight: 60, maxHeight: 75),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 0.0, right: 8.0, top: 4.0, bottom: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Checkbox(
                        value: this._todoItemModel.isDone,
                        onChanged: (value) => _setIsDone(_todoDatabase, value),
                        checkColor: Colors.black54,
                        activeColor: Colors.tealAccent,
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              this._todoItemModel.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //color: Colors.grey[850],
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if(this._todoItemModel.description.isNotEmpty)
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              this._todoItemModel.description,
                              style: TextStyle(
                                fontSize: 12,
                                //color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 0, bottom: 5),
                            child: Text(
                              'Created @$formattedDate',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              //textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                          if (TodoDatabase.isDueToday(
                              this._todoItemModel.dueTo))
                            Badge(
                              badgeColor: Colors.greenAccent,
                              badgeContent: Text('Due today',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.black87,
                                  ),
                              ),
                              shape: BadgeShape.square,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          if (TodoDatabase.isOverDue(
                              this._todoItemModel.dueTo))
                            Badge(
                              badgeColor: Colors.redAccent,
                              badgeContent: Text(
                                'Overdue',
                                style:
                                    TextStyle(fontSize: 8, color: Colors.white),
                              ),
                              shape: BadgeShape.square,
                              borderRadius: BorderRadius.circular(5),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:advanced_todo/database/model/todo/todo_list_model.dart';
import 'package:advanced_todo/state/drawer_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../routes.dart';

class ATTodoListCard extends StatelessWidget {
  final TodoListModel _todoList;
  final bool homePage;

  ATTodoListCard(this._todoList, {this.homePage = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<ATDrawerState>(context, listen: false)
              .setCurrentDrawerEntry('list-' + this._todoList.id);
          Routes.navigateToTodoList(this._todoList);
        },
        child: Card(
          elevation: this.homePage ? 5 : 2,
          //color: this.homePage ? Colors.grey[350] : Colors.white,
          child: Container(
            constraints: BoxConstraints(
                maxHeight: this.homePage && this._todoList.description.isEmpty ? 45 : 60,
            ),
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 4.0, bottom: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          this._todoList.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //color: Colors.grey[850],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if(this._todoList.description.isNotEmpty)
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          this._todoList.description,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

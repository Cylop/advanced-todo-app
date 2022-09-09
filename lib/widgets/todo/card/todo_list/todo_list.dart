import 'package:advanced_todo/database/model/todo/todo_list_model.dart';
import 'package:advanced_todo/database/todo_database/todo_database.dart';
import 'package:advanced_todo/widgets/todo/card/todo_list/todo_list_card_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ATTodoLists extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TodoDatabase _todoDatabase =
    Provider.of<TodoDatabase>(context, listen: false);

    return StreamBuilder<List<TodoListModel>>(
      stream: _todoDatabase.getLists(limit: 50),
      builder:
          (BuildContext context, AsyncSnapshot<List<TodoListModel>> snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                  'You currently dont have any Todolists. Go ahead and create one!'),
            ),
          );
        }
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                horizontalOffset: 200,
                child: FadeInAnimation(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      ATTodoListCard(snapshot.data[index]),
                    ],
                  ),
                ),
              ),
            ),
            childCount: snapshot.hasData ? snapshot.data.length : 0,
          ),
        );
      },
    );
  }
}

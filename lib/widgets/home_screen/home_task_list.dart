import 'package:advanced_todo/database/model/todo/todo_model.dart';
import 'package:advanced_todo/database/todo_database/todo_database.dart';
import 'package:advanced_todo/widgets/todo/home_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class ATHomeTaskList extends StatefulWidget {
  final bool overdue;
  final bool dueToday;
  final bool useDate;
  final DateTime date;

  ATHomeTaskList(
      {Key key,
      this.overdue = false,
      this.dueToday = false,
      this.useDate = false,
      this.date,
      })
      : super(key: key);

  @override
  _ATHomeTaskListState createState() => _ATHomeTaskListState();
}

class _ATHomeTaskListState extends State<ATHomeTaskList>
    with AutomaticKeepAliveClientMixin<ATHomeTaskList> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TodoDatabase _todoDatabase =
        Provider.of<TodoDatabase>(context, listen: false);

    return StreamBuilder<List<AbstractTodoModel>>(
      stream: this.widget.dueToday
          ? _todoDatabase.getMergedTodoListItemsDueToToday()
          : this.widget.overdue
              ? _todoDatabase.getMergedTodoListItemsOverdue()
              : this.widget.useDate ? _todoDatabase.getMergedTodoListItemsDueToDate(this.widget.date, onlyOpen: false) : Stream.empty(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!snapshot.hasData ||
            snapshot.data.length == 0 ||
            snapshot.hasError) {
          return SliverFillRemaining(
            child: Center(
              child: Text('You dont have any ' +
                  (widget.overdue
                      ? 'overdue Todos'
                      : widget.dueToday ? 'Todos due today' : 'Todos for this date') +
                  '.'),
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
                  child: ATHomeListCard(snapshot.data[index]),
                ),
              ),
            ),
            childCount: snapshot.hasData ? snapshot.data.length : 0,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

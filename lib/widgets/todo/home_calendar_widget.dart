import 'package:advanced_todo/state/calendar_state.dart';
import 'package:advanced_todo/widgets/home_screen/home_task_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../persitent_header.dart';
import 'home_calendar_selector.dart';

class ATHomeCalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey<String>('others'),
      slivers: <Widget>[
        SliverOverlapInjector(
          handle:
          NestedScrollView.sliverOverlapAbsorberHandleFor(
              context),
        ),
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[600],
                  width: 1,
                ),
              ),
            ),
            child: ATHomeCalendarSelectorWidget(),
          ),
        ),
        Consumer<CalendarState>(
          builder: (context, value, child) => ATHomeTaskList(
            useDate: true,
            date: value.getSelectedDate,
          ),
        ),
      ],
    );
  }
}

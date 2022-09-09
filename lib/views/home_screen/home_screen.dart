import 'package:advanced_todo/state/calendar_state.dart';
import 'package:advanced_todo/widgets/drawer/drawer_widget.dart';
import 'package:advanced_todo/widgets/home_screen/home_task_list.dart';
import 'package:advanced_todo/widgets/todo/home_calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: CalendarState(),
        ),
      ],
      child: Scaffold(
        drawer: ATDrawer(),
        body: DefaultTabController(
          length: 3, // This is the number of tabs.
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    bottom: false,
                    sliver: SliverAppBar(
                      title: const Text('Dashboard'),
                      floating: true,
                      pinned: true,
                      snap: false,
                      primary: true,
                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        tabs:[
                          Text('Overdue'),
                          Text('Due today'),
                          Text('Others'),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        key: PageStorageKey<String>('overdue'),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                            NestedScrollView.sliverOverlapAbsorberHandleFor(
                                context),
                          ),
                          ATHomeTaskList(
                            overdue: true,
                            dueToday: false,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                    builder: (BuildContext context) {
                      return CustomScrollView(
                        key: PageStorageKey<String>('due-today'),
                        slivers: <Widget>[
                          SliverOverlapInjector(
                            handle:
                            NestedScrollView.sliverOverlapAbsorberHandleFor(
                                context),
                          ),
                          ATHomeTaskList(
                            overdue: false,
                            dueToday: true,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  bottom: false,
                  child: Builder(
                      builder: (_) => ATHomeCalendarWidget(),
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

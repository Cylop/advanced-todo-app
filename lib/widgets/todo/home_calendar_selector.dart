import 'package:advanced_todo/database/model/todo/todo_item_model.dart';
import 'package:advanced_todo/database/todo_database/todo_database.dart';
import 'package:advanced_todo/state/calendar_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ATHomeCalendarSelectorWidget extends StatefulWidget {
  @override
  _ATHomeCalendarWidgetState createState() => _ATHomeCalendarWidgetState();
}

class _ATHomeCalendarWidgetState extends State<ATHomeCalendarSelectorWidget> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ATHomeCalendarSelectorWidget> {
  AnimationController _animationController;
  CalendarController _calendarController;

  DateTime startDate;
  DateTime endDate;

  DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    ///initial start and end dates
    final DateTime now = DateTime.now();
    selectedDate = now;
    startDate = now.subtract(Duration(days: now.weekday - 1));
    endDate = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));

    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildTableCalendarWithBuilders(context);
  }

  Widget _buildTableCalendarWithBuilders(BuildContext context) {
    TodoDatabase _todoDatabase = Provider.of<TodoDatabase>(context, listen: false);
    CalendarState calendarState = Provider.of<CalendarState>(context, listen: false);
    return FutureBuilder(
        future: _todoDatabase.getTodosGroupByDate(startDate, endDate),
        builder: (context, AsyncSnapshot<Map<DateTime, List<TodoItemModel>>> snapshot) {
          return TableCalendar(
            locale: 'en_US',
            rowHeight: 50,
            calendarController: _calendarController,
            events: snapshot.data,
            //holidays: _holidays,
            initialCalendarFormat: CalendarFormat.week,
            formatAnimation: FormatAnimation.slide,
            startingDayOfWeek: StartingDayOfWeek.monday,
            availableGestures: AvailableGestures.all,
            availableCalendarFormats: const {
              CalendarFormat.week: '',
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              weekendStyle: TextStyle().copyWith(color: Colors.teal[200]),
              holidayStyle: TextStyle().copyWith(color: Colors.redAccent[100]),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle().copyWith(color: Colors.grey[400]),
              weekdayStyle: TextStyle().copyWith(color: Colors.white)
            ),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonVisible: false,
            ),
            builders: CalendarBuilders(
              selectedDayBuilder: (context, date, _) {
                return FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                    //color: Colors.deepOrange[300],
                    decoration: BoxDecoration(
                      color: Colors.teal[200],
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    width: 100,
                    height: 100,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(
                        fontSize: 16.0,
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                );
              },
              todayDayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  //color: Colors.amber[400],
                  width: 100,
                  height: 100,
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(
                      fontSize: 16.0,
                      color: Colors.grey[300],
                    ),
                  ),
                );
              },
              markersBuilder: (context, date, events, holidays) {
                final children = <Widget>[];

                if (events.isNotEmpty) {
                  children.add(
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: _buildEventsMarker(date, events),
                    ),
                  );
                }

                if (holidays.isNotEmpty) {
                  children.add(
                    Positioned(
                      right: -2,
                      top: -2,
                      child: _buildHolidaysMarker(),
                    ),
                  );
                }

                return children;
              },
            ),
            onDaySelected: (date, events, holidays) {
              setState(() {
                this.selectedDate = date;
              });
              calendarState.setSelectedDate = date;
              _animationController.forward(from: 0.0);
            },
            onVisibleDaysChanged: (first, last, format) {
              setState(() {
                startDate = first;
                endDate = last;
              });
            },
            //onCalendarCreated: _onCalendarCreated,
          );
        }
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
            ? Colors.brown[300]
            : Colors.teal[200],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: _calendarController.isSelected(date) ? Colors.white : Colors.grey[900],
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

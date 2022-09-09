// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advanced_todo/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        drawer: ATDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text('Dashboard'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () async {},
                ),
              ],
              floating: true,
              snap: true,
              flexibleSpace: Placeholder(),
              bottom: TabBar(
                tabs: [
                  Text('Overdue'),
                  Text('Due Today'),
                  Text('Calendar'),
                ],
              ),
            ),
            ATHomeTaskList(),
          ],
        ),
      );
    }
  });

  //Drawer Top 5 List STreambuilder
  ATDrawerListTile(
    leading: Icon(Icons.circle, size: 4,),
    title: Text('Your Top 5 Todo lists'),
  ),
  StreamBuilder(
  stream: _todoDatabase.getLists(),
  builder: (BuildContext context,
  AsyncSnapshot<List<TodoListModel>> listSnapshot) {
  if (!listSnapshot.hasData || listSnapshot.data.isEmpty) {
  return ListTile(
  title:
  Center(child: Text('You dont have any lists yet')),
  subtitle: Center(child: Text('Create one here!')),
  );
  }
  return Column(
  children: listSnapshot.data.map((item) {
  return ATDrawerListTile(
  autoClose: true,
  drawerId: 'list-' + item.id,
  title: Text(item.title),
  onTap: () {
  Routes.navigateToTodoList(item);
  },
  );
  }).toList(),
  );
  },
  ),
  Divider(),
}

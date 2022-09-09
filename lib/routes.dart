import 'package:advanced_todo/database/model/todo/todo_list_model.dart';
import 'package:advanced_todo/views/home_screen/home_screen.dart';
import 'package:advanced_todo/views/home_screen/todo_list_screen/add_todo_list_screen/add_todo_list_screen.dart';
import 'package:advanced_todo/views/home_screen/todo_list_screen/todo_list_screen.dart';
import 'package:advanced_todo/views/home_screen/todo_list_screen/todo_screen/add_todo_screen.dart';
import 'package:advanced_todo/views/home_screen/todo_list_screen/todo_screen/todo_overview_screen.dart';
import 'package:advanced_todo/views/login_screen/login_screen.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sailor/sailor.dart';

import 'database/model/todo/todo_item_model.dart';

class Routes {
  static final sailor = Sailor(
    options: SailorOptions(
      defaultTransitions: [
        SailorTransition.fade_in,
      ],
      defaultTransitionDuration: Duration(milliseconds: 250),
      defaultTransitionCurve: Curves.easeInOut,
    ),
  );

  static const String ROUTE_HOME = '/initial';
  static const String ROUTE_LOGIN = '/login';
  static const String ROUTE_TODO_LISTS = '/todo_lists';
  static const String ROUTE_ADD_TODO_LIST = '/add_todo_lists';
  static const String ROUTE_TODO_LISTS_TODOS = '/todo_lists/overview';
  static const String ROUTE_TODO_LISTS_ADD_TODO = '/todo_lists/overview/add';


  static void navigateToHome() {
    sailor.navigate(
      ROUTE_HOME,
      navigationType: NavigationType.pushReplace,
    );
  }

  static void navigateToLogin() {
    sailor.navigate(
      ROUTE_LOGIN,
      navigationType: NavigationType.pushReplace,
    );
  }

  static void navigateToTodoLists() {
    sailor.navigate(
      ROUTE_TODO_LISTS,
      navigationType: NavigationType.pushReplace,
    );
  }

  static Future<TodoListModel> navigateToAddTodoList() async {
    return sailor.navigate(
      ROUTE_ADD_TODO_LIST,
    );
  }

  static void navigateToTodoList(TodoListModel todoList) {
    sailor.navigate(
      ROUTE_TODO_LISTS_TODOS,
      navigationType: NavigationType.pushReplace,
      params: {
        'todo_list': todoList,
      },
    );
  }

  static Future<TodoItemModel> navigateToAddTodoItemScreen() {
    return sailor.navigate(
      ROUTE_TODO_LISTS_ADD_TODO,
    );
  }

  static void createRoutes() {
    sailor.addRoutes([
      SailorRoute(
        name: ROUTE_HOME,
        builder: (context, args, params) {
          return HomeScreen();
        },
      ),
      SailorRoute(
        name: ROUTE_LOGIN,
        builder: (context, args, params) {
          return LoginScreen();
        },
        defaultTransitions: [
          SailorTransition.fade_in,
        ],
        defaultTransitionDuration: Duration(milliseconds: 500),
        defaultTransitionCurve: Curves.easeInOut,
      ),
      SailorRoute(
        name: ROUTE_TODO_LISTS,
        builder: (context, args, params) {
          return ATTodoListScreen();
        },
      ),
      SailorRoute(
        name: ROUTE_ADD_TODO_LIST,
        builder: (context, args, params) {
          return ATAddTodoListScreen();
        },
      ),
      SailorRoute(
        name: ROUTE_TODO_LISTS_TODOS,
        builder: (context, args, params) {
          return ATTodoOverviewScreen(params.param('todo_list'));
        },
        params: [
          SailorParam<TodoListModel>(
            isRequired: true,
            name: 'todo_list'
          )
        ],
      ),
      SailorRoute(
        name: ROUTE_TODO_LISTS_ADD_TODO,
        builder: (context, args, params) {
          return ATAddTodoItemScreen();
        },
      ),
    ]);
  }
}

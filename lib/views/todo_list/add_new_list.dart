import 'package:flutter/material.dart';

class ATAddTodoList extends StatefulWidget {
  @override
  _ATAddTodoListState createState() => _ATAddTodoListState();
}

class _ATAddTodoListState extends State<ATAddTodoList> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

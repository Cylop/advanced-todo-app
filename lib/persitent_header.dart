import 'package:flutter/material.dart';

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: double.infinity,
          child: Card(
            margin: EdgeInsets.all(0),
            elevation: 5.0,
            child: Center(child: widget),
          ),
        );
      }
    );
  }

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 145.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
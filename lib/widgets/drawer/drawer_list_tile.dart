import 'package:advanced_todo/state/drawer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ATDrawerListTile extends StatelessWidget {

  final String drawerId;
  final bool autoClose;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final bool isThreeLine;
  final bool dense;
  final VisualDensity visualDensity;
  final ShapeBorder shape;
  final EdgeInsetsGeometry contentPadding;
  final bool enabled;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final MouseCursor mouseCursor;
  final Color focusColor;
  final Color hoverColor;
  final FocusNode focusNode;
  final bool autofocus;
  final Color tileColor;
  final Color selectedTileColor;

  ATDrawerListTile({
    @required this.drawerId,
    this.autoClose = false,
    Key key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.dense,
    this.visualDensity,
    this.shape,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.onLongPress,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
    this.tileColor,
    this.selectedTileColor,
  });

  @override
  Widget build(BuildContext context) {
    final ATDrawerState _drawerState = Provider.of<ATDrawerState>(context, listen: false);

    void _callBack() {
      _drawerState.setCurrentDrawerEntry(this.drawerId);
      if(this.autoClose && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      this.onTap();
    }

    return Consumer<ATDrawerState>(
      builder: (context, drawerState, child) {
        return ListTile(
          key: this.key,
          subtitle: this.subtitle,
          title: this.title,
          hoverColor: this.hoverColor,
          shape: this.shape,
          leading: this.leading,
          isThreeLine: this.isThreeLine,
          tileColor: this.tileColor,
          enabled: this.enabled,
          mouseCursor: this.mouseCursor,
          onTap: _callBack,
          autofocus: this.autofocus,
          focusColor: this.focusColor,
          contentPadding: this.contentPadding,
          dense: this.dense,
          focusNode: this.focusNode,
          onLongPress: this.onLongPress,
          selected: drawerState.getCurrentDrawerEntry == this.drawerId,
          selectedTileColor: this.selectedTileColor,
          trailing: this.trailing,
          visualDensity: this.visualDensity,
        );
      },
    );
  }

  get getDrawerId => this.drawerId;

}
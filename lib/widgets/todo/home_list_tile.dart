import 'package:flutter/material.dart';

class ATHomeListTile extends StatelessWidget {
  final Widget widget;
  final bool isFirst;
  final bool isLast;

  const ATHomeListTile(
      {Key key, this.widget, this.isFirst = false, this.isLast = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 70,
      ),
      child: LayoutBuilder(
        builder:(context, constraints) => Padding(
          padding: !isFirst
              ? const EdgeInsets.only(left: 10.0)
              : const EdgeInsets.only(left: .0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isFirst) this._connector(context, constraints),
              SizedBox(
                width: isFirst ? 0 : 0,
              ),
              if(this.isFirst) this._addConnectorToFirstWidget(context, this.widget),
              if(!this.isFirst) this.widget
            ],
          ),
        ),
      ),
    );
  }

  Widget _addConnectorToFirstWidget(BuildContext context, Widget widget) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.directional(
          textDirection: TextDirection.ltr,
          bottom: 0,
          start: 10,
          child: Container(
            height: 5,
            width: 0,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Colors.black54,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: size.width,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              widget,
            ],
          ),
        ),
      ],
    );
  }

  Widget _connector(BuildContext context, BoxConstraints constraints) {
    return Row(
      children: [
        this._verticalLine(context, constraints),
        this._horizontalLine(),
      ],
    );
  }

  Widget _verticalLine(BuildContext context, BoxConstraints constraints) {
    double height = constraints.loosen().biggest.height;
    return Padding(
      padding: isFirst
          ? EdgeInsets.only(top: 30)
          : isLast ? EdgeInsets.only(bottom: 30) : EdgeInsets.all(0),
      child: Container(
        height: isFirst || isLast ? 30 : height,
        width: 0,
        alignment: isFirst
            ? Alignment.bottomLeft
            : this.isLast ? Alignment.topLeft : Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.black54,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _horizontalLine() {
    return Container(
      height: 0,
      width: isFirst ? 10 : 20,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black54,
            width: 2,
          ),
        ),
      ),
    );
  }
}

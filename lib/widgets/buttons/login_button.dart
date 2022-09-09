import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ATLoginButton extends StatelessWidget {
  final String text;
  final Function _onPressed;

  ATLoginButton(this.text, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: this._onPressed != null ? this._onPressed : {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/google-icon.svg',
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                this.text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

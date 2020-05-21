import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {

  CustomRaisedButton({this.child, this.onPressed, this.borderRadius:5.0, this.color, this.textColor});

  final Widget child;
  final Color color;
  final double borderRadius;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 60.0,
      child: FlatButton(
        onPressed: onPressed,
        color: color,
        disabledColor: color,
        textColor: textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: Colors.white,
              width: 1,
              style: BorderStyle.solid,

            )),

        child: child,
      ),
    );
  }
}

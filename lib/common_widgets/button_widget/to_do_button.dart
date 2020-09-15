import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_raised_button.dart';

class ToDoButton extends CustomRaisedButton {
  ToDoButton({
//    @required String assetName,
    @required String text,
    double textSize,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
    bool isEnabled = true,
    bool isLoading = false,
  })  :
//        assert(assetName != null),
        assert(text != null),
        super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
//              Image.asset(assetName),
              !isLoading
                  ? Text(
                      text,
                      style: TextStyle(
                          fontSize: getDynamicTextSize(18),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Quicksand'),
                    )
                  : CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
//              Opacity(
//                opacity: 0.0,
//                child: Image.asset(assetName),
//              )
            ],
          ),
          color: isEnabled ? backgroundColor : backgroundColor.withOpacity(.65),
          textColor: textColor,
          onPressed: isEnabled ? onPressed : null,
        );
}

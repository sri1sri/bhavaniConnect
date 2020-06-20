import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomAppBarDark extends StatelessWidget {
  CustomAppBarDark({
    this.primaryText,
    this.leftActionBar,
    this.rightActionBar,
    this.leftAction,
    this.rightAction,
    this.tabBarWidget,
  });

  final Widget leftActionBar;
  final Widget rightActionBar;
  final String primaryText;
  final VoidCallback leftAction;
  final VoidCallback rightAction;
  final Widget tabBarWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: InkWell(
                    child: leftActionBar == null
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : leftActionBar,
                    onTap: leftAction,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    primaryText == null
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Text(
                            primaryText,
                            textAlign: TextAlign.center,
                            style: appBarTitleStyle,
                          ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    // top: 45,
                    right: 20,
                  ),
                  child: InkWell(
                    child: rightActionBar == null
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : rightActionBar,
                    onTap: rightAction,
                  ),
                ),
              ],
            ),
          ),
          tabBarWidget == null
              ? Container(
                  height: 0,
                  width: 0,
                )
              : tabBarWidget,
        ],
      ),
    );
  }
}

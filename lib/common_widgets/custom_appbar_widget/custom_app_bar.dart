
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar(
      {
        this.primaryText,
        this.secondaryText,
        this.leftActionBar,
        this.rightActionBar,
        this.leftAction,
      this.rightAction,
        this.tabBarWidget,
});

  final Widget leftActionBar;
  final Widget rightActionBar;
  final String primaryText;
  final String secondaryText;
  final VoidCallback leftAction;
  final VoidCallback rightAction;
  final Widget tabBarWidget;

  @override
  Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[100],
    ),
    width: MediaQuery.of(context).size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 55,
                  left: 20,
                ),
                child: InkWell(
                  child: leftActionBar == null ? Container(
                    height: 0, width: 0,
                  ): leftActionBar,
                  onTap: leftAction,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 55,
                  right: 20,
                ),
                child: InkWell(
                  child: rightActionBar == null ? Container(
                    height: 0, width: 0,
                  ) : rightActionBar,
                  onTap: rightAction,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              primaryText == null ? Container(height: 0, width: 0,): Text(
            primaryText,
            textAlign: TextAlign.center,
            style: titleStyle,
          ),

              secondaryText == null ? Container(height: 0, width: 0,): Text(
                secondaryText,
                textAlign: TextAlign.center,
                style: bigTitleStyle,
              ),
            ],

          ),
        ),
        tabBarWidget == null ? Container(height: 0,width: 0,) :tabBarWidget,


      ],

    ),
  );
  }


}

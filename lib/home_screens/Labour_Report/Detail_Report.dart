import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_DetailReport(),
    );
  }
}

class F_DetailReport extends StatefulWidget {
  @override
  _F_DetailReport createState() => _F_DetailReport();
}

class _F_DetailReport extends State<F_DetailReport> {
  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);

  }

  Widget offlineWidget (BuildContext context){
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Scaffold(
          body: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: PreferredSize(
          preferredSize:
          Size.fromHeight(70),
          child: CustomAppBarDark(
            leftActionBar: Icon(Icons.arrow_back_ios,size: 25,color: Colors.white,),
            leftAction: (){
              Navigator.pop(context,true);
            },
            primaryText: 'Detail Report',
            tabBarWidget: null,
          ),
        ),
        body:ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0),
              topLeft: Radius.circular(50.0)),
          child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subtext("Created On", "29/Oct/2020"),
                              subtext("Created By", "Vasanth (Manager)"),
                              subtext("Site", "Bhavani Vivan"),
                              subtext("Block", "2nd"),
                              subtext("Labour Type", "Self Employees"),
                              subtext("Dealer Name", "Vasanth Agencies"),
                              subtext("No. of People", "20"),
                              subtext("Purpose", "Plumbing & Carpenting"),
                            ],
                          ),
                        ),
                        SizedBox(height: 550,),
                      ]
                  )
              )),
        ),
    );
  }
}

Widget subtext(String _left, String _right) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
            '$_left :',
            style: subTitleStyle
        ),
        Text(
            '$_right',
            style: descriptionStyleDarkBlur1
        ),
      ],
    ),
  );
}

Widget totalsubtext(String _left, String _right) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
            '$_left :',
            style: titleStyle
        ),
        Text(
            '$_right',
            style: highlight
        ),
      ],
    ),
  );
}

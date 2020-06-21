import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class DisplayEmployeeAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_DisplayEmployeeAttendance(),
    );
  }
}

class F_DisplayEmployeeAttendance extends StatefulWidget {
  @override
  _F_DisplayEmployeeAttendance createState() => _F_DisplayEmployeeAttendance();
}

class _F_DisplayEmployeeAttendance extends State<F_DisplayEmployeeAttendance> {
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
          primaryText: 'Employee Attendance',
          tabBarWidget: null,
        ),
      ),
      body:ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0),
            topLeft: Radius.circular(50.0)),
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Text("Vasanthakumar's attendance",style: titleStyle,),
                  Text("for October month",style: descriptionStyleDarkBlur1,),
                  SizedBox(height: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      attendanceCard("29","Oct","2020","10.30 am","05.45 pm"),
                      attendanceCard("30","Oct","2020","10.50 am","06.33 pm"),
                      attendanceCard("02","Nov","2020","11.00 am","07.50 pm"),
                      attendanceCard("06","Nov","2020","10.22 am","06.32 pm"),
                    ],
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
Widget attendanceCard(String day,String month,String year,String inTime,String outTime) {
  return Padding(
    padding: const EdgeInsets.only(top:10.0,bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15)
          ),
          height: getDynamicHeight(90),
          width: getDynamicWidth(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(day,style: titleStylelight,),
              Text(month,style: descriptionStyleLite1,),
              Text(year,style: descriptionStyleLite1,)
            ],
          ),
        ),
        SizedBox(width: getDynamicWidth(10),),
        Container(
            decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)
            ),
            height: getDynamicHeight(90),
            width: getDynamicWidth(300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.call_received,size: 30,color: Colors.green,),
                    SizedBox(width: 7,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Punch In",style: descriptionStyleDark,),
                        SizedBox(height: getDynamicHeight(5),),
                        Text(inTime,style: subTitleStyleDark1,)
                      ],
                    )
                  ],
                ),
                SizedBox(width: getDynamicWidth(5),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: getDynamicWidth(2),
                    height: double.maxFinite,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: getDynamicWidth(5),),
                Row(
                  children: [
                    Icon(Icons.call_made,size: 30,color: Colors.red,),
                    SizedBox(width: getDynamicWidth(7),),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Punch Out",style: descriptionStyleDark,),
                        SizedBox(height: getDynamicHeight(5),),
                        Text(outTime,style: subTitleStyleDark1,)
                      ],
                    )
                  ],
                ),
              ],
            )
        )
      ],
    ),
  );
}
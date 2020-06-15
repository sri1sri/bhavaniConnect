import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Attendance/Employee_Attendance_Search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Add_Attendance.dart';

class DisplayAttendance extends StatefulWidget {
  final String currentUserId;

  const DisplayAttendance({Key key, this.currentUserId}) : super(key: key);
  @override
  _DisplayAttendance createState() => _DisplayAttendance();
}

class _DisplayAttendance extends State<DisplayAttendance> {
  int selectedValue;
  int monthSelected = DateTime.now().month;
  int yearSelected = DateTime.now().year;
  DateTime now = DateTime.now();
  String userSelected;

  UserRoles userRole;
  String userRoleValue;

  String userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userSelected = widget.currentUserId;

    getUserParams();
  }

  getUserParams() async {
    var prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("userRole");
    String name = prefs.getString("userName");

    setState(() {
      userRole = userRoleValues[role];
      userRoleValue = role;
      userName = name;
    });
  }

  SearchDialog(BuildContext context) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 300.0,
        width: 300.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Container(
                child: CupertinoPicker(
                  onSelectedItemChanged: (value) {
                    setState(() {
                      selectedValue = value + 1;
                      monthSelected = value + 1;
                    });
                  },
                  itemExtent: 40.0,
                  children: const [
                    Text(
                      'January',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'February',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'March',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'April',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'May',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'June',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'July',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'August',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'September',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'October',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'November',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                    Text(
                      'December',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text("Select a Month", style: appBarTitleStyle),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Search", style: appBarTitleStyle),
                  ),
                ),
              ),
            ),
            Align(
              // These values are based on trial & error method
              alignment: Alignment(1.05, -1.05),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
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
            preferredSize: Size.fromHeight(72),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                            top: 45,
                            left: 20,
                          ),
                          child: InkWell(
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 25,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.pop(context, true);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Daily Attendance",
                                textAlign: TextAlign.center,
                                style: appBarTitleStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 35,
                              right: 10,
                            ),
                            child: Row(
                              children: [
                                userRole == UserRoles.Manager ||
                                        userRole == UserRoles.Admin
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.people,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          GoToPage(context,
                                              SearchEmployeeAttendance(
                                            employeeSearch: (userId, month) {
                                              setState(() {
                                                if (userId != null) {
                                                  userSelected = userId;
                                                }

                                                if (month != null) {
                                                  monthSelected = month;
                                                }
                                              });
                                            },
                                          ));
                                        },
                                      )
                                    : Container(),
                                IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    SearchDialog(context);
                                  },
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        body: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
          child: Container(
              color: Colors.white,
              height: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            DateTimeUtils.daysInMonth(
                                monthSelected, yearSelected), (index) {
                          DateTime dateTime =
                              DateTime(yearSelected, monthSelected, index + 1);
                          if (now
                                  .toUtc()
                                  .difference(dateTime.toUtc())
                                  .inMilliseconds >
                              0) {
                            return attendanceCard(dateTime);
                          } else {
                            return Container();
                          }
                        }),
                      ),
                    ),
                  ]))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  GoToPage(context, AddAttendance(currentUserId: userSelected));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: backgroundColor.withOpacity(0.9),
                  ),
                  height: 35,
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ADD",
                        style: subTitleStyleLight1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget attendanceCard(DateTime datetime) {
    String day;
    String month;
    String year;
    String inTime;
    String outTime;

    String documentId =
        datetime.millisecondsSinceEpoch.toString() + userSelected;
    print(documentId);
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('attendance')
            .document(documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            day = DateTimeUtils.formatDay(datetime);
            month = DateTimeUtils.formatAbbrMonth(datetime);
            year = DateTimeUtils.yearFormat(datetime);
            if (snapshot.data != null && snapshot.data.data != null) {
              inTime = DateTimeUtils.hourMinuteFormat(
                  (snapshot.data.data['punch_in'] as Timestamp).toDate());
              outTime = DateTimeUtils.hourMinuteFormat(
                  (snapshot.data.data['punch_out'] as Timestamp).toDate());
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  height: 90,
                  width: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day,
                        style: titleStylelight,
                      ),
                      Text(
                        month,
                        style: descriptionStyleLite1,
                      ),
                      Text(
                        year,
                        style: descriptionStyleLite1,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: backgroundColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    height: 90,
                    width: 300,
                    child: inTime == null
                        ? Text(
                            DateTimeUtils.weekDayFormat(datetime) == "Sunday"
                                ? "Holiday"
                                : "Absent",
                            style: subTitleStyleDark1,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.call_received,
                                    size: 30,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Punch In",
                                        style: descriptionStyleDark,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        inTime,
                                        style: subTitleStyleDark1,
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 2,
                                  height: double.maxFinite,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.call_made,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Punch Out",
                                        style: descriptionStyleDark,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        outTime,
                                        style: subTitleStyleDark1,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ))
              ],
            );
          }
        },
      ),
    );
  }
}

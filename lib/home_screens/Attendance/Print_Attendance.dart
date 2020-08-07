import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Attendance/Daily_Attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';
import 'package:toast/toast.dart';
import 'Monthly_Attendance.dart';

class AttendanceFilter extends StatefulWidget {
  @override
  _AttendanceFilter createState() => _AttendanceFilter();
}

class _AttendanceFilter extends State<AttendanceFilter> {
  DateTime selectedDateFrom = DateTime(
    DateTime.now().year,
    1,
    1,
  );
  DateTime selectedDateTo =
      DateTimeUtils.currentDayDateTimeNow.add(Duration(days: 1));

  // DateTime selectedDateFrom = DateTime.now();
  // DateTime selectedDateTo = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");

  String constructionId = '';
  String selectedConstructionSite = '';

  String selectedUserId = '';
  String selectedUserName = '';

  String selectedMonthName = "January";
  int selectedMonth = 1;

  Map<String, int> monthsName = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };

  bool validated = false;

  @override
  void initState() {
    super.initState();
    // selectedDateFrom = widget.startDate;
    // selectedDateTo = widget.endDate;
  }

  Future<Null> showPickerFrom(BuildContext context) async {
    final DateTime pickedFrom = await showDatePicker(
      context: context,
      initialDate: selectedDateFrom,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (pickedFrom != null) {
      setState(() {
        print(customFormat.format(pickedFrom));
        selectedDateFrom = pickedFrom;
      });
    }
  }

  Future<Null> showPickerTo(BuildContext context) async {
    final DateTime pickedTo = await showDatePicker(
      context: context,
      initialDate: selectedDateTo,
      firstDate: DateTime(1930),
      lastDate: DateTime.now().add(Duration(days: 1)),
    );
    if (pickedTo != null) {
      setState(() {
        print(customFormat.format(pickedTo));
        selectedDateTo = pickedTo;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool visible = true;
  int _n = 0;
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
        child: CustomAppBarDark(
          leftActionBar: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.white,
          ),
          leftAction: () {
            Navigator.pop(context, true);
          },
          rightActionBar: Container(
            width: getDynamicHeight(10),
          ),
          rightAction: () {
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Search Attendance',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: getDynamicHeight(50),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Construction Site",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: getDynamicHeight(15),
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection(
                                        AppConstants.prod + "constructionSite")
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    List<String> items = snapshot.data.documents
                                        .map((e) => (e.documentID.toString()))
                                        .toList();
                                    return DropdownSearch(
                                      showSelectedItem: true,
                                      maxHeight: 400,
                                      mode: Mode.MENU,
                                      items: items,
                                      dropdownItemBuilder:
                                          (context, value, isTrue) {
                                        return ListTile(
                                          title: Text(snapshot.data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString()),
                                          selected: isTrue,
                                          onTap: () {
                                            setState(() {
                                              selectedConstructionSite =
                                                  snapshot.data.documents
                                                      .firstWhere((element) =>
                                                          element.documentID ==
                                                          value)['name']
                                                      .toString();
                                              constructionId = value;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      label: "Construction Site",
                                      onChanged: (value) {},
                                      selectedItem: selectedConstructionSite ??
                                          "Choose Construction Site",
                                      showSearchBox: true,
                                      validate: (value) {
                                        if (validated &&
                                            (selectedConstructionSite == null ||
                                                selectedConstructionSite
                                                    .isEmpty)) {
                                          return "Construction Site cannot be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                height: getDynamicHeight(20),
                              ),
                              Text(
                                "Employee Name",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: getDynamicHeight(15),
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection(AppConstants.prod + "userData")
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    List<String> items = snapshot.data.documents
                                        .map((e) => (e.documentID.toString()))
                                        .toList();

                                    return DropdownSearch(
                                      showSelectedItem: true,
                                      maxHeight: 400,
                                      mode: Mode.MENU,
                                      items: items,
                                      dropdownItemBuilder:
                                          (context, value, isTrue) {
                                        return ListTile(
                                          title: Text(snapshot.data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString()),
                                          selected: isTrue,
                                          onTap: () {
                                            setState(() {
                                              selectedUserName = snapshot
                                                  .data.documents
                                                  .firstWhere((element) =>
                                                      element.documentID ==
                                                      value)['name']
                                                  .toString();
                                              selectedUserId = value;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      label: "Employee Name",
                                      onChanged: (value) {},
                                      selectedItem: selectedUserName ??
                                          "Choose Employee Name",
                                      showSearchBox: true,
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                height: getDynamicHeight(20),
                              ),
                              // selectedUserName != ""
                              //     ? Container()
                              //     : Text(
                              //         "Choose Month",
                              //         style: titleStyle,
                              //       ),
                              // selectedUserName != ""
                              //     ? Container()
                              //     : SizedBox(
                              //         height: getDynamicHeight(15),
                              //       ),
                              // selectedUserName != ""
                              //     ? Container()
                              //     : Container(
                              //         width: double.infinity,
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: 13, horizontal: 10),
                              //         decoration: BoxDecoration(
                              //           border: Border.all(
                              //             color: Color(0xffBFBFBF),
                              //             width: 1,
                              //           ),
                              //           borderRadius: BorderRadius.circular(5),
                              //         ),
                              //         child: DropdownButtonHideUnderline(
                              //           child: DropdownButton<String>(
                              //             hint: Text("Choose Month"),
                              //             value: selectedMonthName,
                              //             isDense: true,
                              //             onChanged: (newValue) {
                              //               setState(() {
                              //                 selectedMonthName = newValue;
                              //                 selectedMonth =
                              //                     monthsName[newValue];
                              //               });
                              //               print(selectedMonthName);
                              //             },
                              //             items: monthsName.keys
                              //                 .map((String value) {
                              //               return DropdownMenuItem<String>(
                              //                 value: value,
                              //                 child: Text(value),
                              //               );
                              //             }).toList(),
                              //           ),
                              //         ),
                              //       ),
                              SizedBox(
                                height: getDynamicHeight(20),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            25,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "From",
                                          style: titleStyle,
                                        ),
                                        SizedBox(
                                          height: getDynamicHeight(15),
                                        ),
                                        GestureDetector(
                                          onTap: () => showPickerFrom(context),
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  size: 18.0,
                                                  color: backgroundColor,
                                                ),
                                                SizedBox(
                                                  width: getDynamicWidth(10),
                                                ),
                                                Text(
                                                    '${customFormat2.format(selectedDateFrom)}',
                                                    style: subTitleStyle),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            25,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "To",
                                          style: titleStyle,
                                        ),
                                        SizedBox(
                                          height: getDynamicHeight(15),
                                        ),
                                        GestureDetector(
                                          onTap: () => showPickerTo(context),
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  size: 18.0,
                                                  color: backgroundColor,
                                                ),
                                                SizedBox(
                                                  width: getDynamicWidth(10),
                                                ),
                                                Text(
                                                    '${customFormat2.format(selectedDateTo)}',
                                                    style: subTitleStyle),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getDynamicHeight(30),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: getDynamicHeight(50),
                              width: getDynamicWidth(300),
                              child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState.validate() &&
                                      selectedConstructionSite != '' &&
                                      selectedUserName != '') {
                                    _formKey.currentState.save();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PrintDailyAttendance(
                                          selectedDateFrom,
                                          selectedDateTo,
                                          constructionId,
                                          selectedConstructionSite,
                                          selectedUserId,
                                          selectedUserName,
                                        ),
                                      ),
                                    );
                                  } else {
                                    print('empty fields');
                                    Toast.show(
                                        "Please select Construction site and Employee name",
                                        context,
                                        duration: 3);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                          child: Text(
                                        "Daily Attendance",
                                        style: activeSubTitleStyle,
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getDynamicHeight(15),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: getDynamicHeight(50),
                              width: getDynamicWidth(300),
                              child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState.validate() &&
                                      selectedConstructionSite != '') {
                                    if (selectedUserName != '') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PrintMonthlyAttendance(
                                            selectedDateFrom,
                                            selectedDateTo,
                                            constructionId,
                                            selectedConstructionSite,
                                            selectedUserId,
                                            selectedUserName,
                                            selectedMonth: selectedMonth,
                                          ),
                                        ),
                                      );
                                    } else if (selectedMonthName != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PrintMonthlyAttendance(
                                            selectedDateFrom,
                                            selectedDateTo,
                                            constructionId,
                                            selectedConstructionSite,
                                            selectedUserId,
                                            selectedUserName,
                                            selectedMonth: selectedMonth,
                                          ),
                                        ),
                                      );
                                    } else {
                                      print('Employee empty fields');
                                      Toast.show(
                                          "Please select Employee Name OR Month",
                                          context,
                                          duration: 3);
                                    }
                                  } else {
                                    print('empty fields');
                                    Toast.show(
                                        "Please select Construction Site",
                                        context,
                                        duration: 3);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                          child: Text(
                                        "Monthly Attendance",
                                        style: activeSubTitleStyle,
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

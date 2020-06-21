import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class SearchEmployeeAttendance extends StatefulWidget {
  final Function(String userId, int month) employeeSearch;

  const SearchEmployeeAttendance({Key key, this.employeeSearch})
      : super(key: key);

  @override
  _SearchEmployeeAttendance createState() => _SearchEmployeeAttendance();
}

class _SearchEmployeeAttendance extends State<SearchEmployeeAttendance> {
  int _n = 0;
  int selectedValue;
  int selectedMonthNumber;
  String selectedMonth;
  String selectedUserId;
  String selectedUserName;
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
          primaryText: 'Employee Attendance',
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: getDynamicHeight(20),
                  ),
                  Text(
                    "Employee Name",
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: getDynamicHeight(20),
                  ),
                  StreamBuilder(
                    stream: Firestore.instance
                        .collection(AppConstants.prod + "userData")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        List<String> items = snapshot.data.documents
                            .map((e) => (e.documentID.toString()))
                            .toList();

                        return DropdownSearch(
                          showSelectedItem: true,
                          maxHeight: 400,
                          mode: Mode.MENU,
                          items: items,
                          dropdownItemBuilder: (context, value, isTrue) {
                            return ListTile(
                              title: Text(snapshot.data.documents
                                  .firstWhere((element) =>
                                      element.documentID == value)['name']
                                  .toString()),
                              selected: isTrue,
                              onTap: () {
                                setState(() {
                                  selectedUserName = snapshot.data.documents
                                      .firstWhere((element) =>
                                          element.documentID == value)['name']
                                      .toString();
                                  selectedUserId = value;
                                });
                                Navigator.of(context).pop();
                              },
                            );
                          },
                          label: "Employee Name",
                          onChanged: (value) {},
                          selectedItem:
                              selectedUserName ?? "Choose Employee Name",
                          showSearchBox: true,
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: getDynamicHeight(20),
                  ),
                  Text(
                    "Attendance Month",
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: getDynamicHeight(20),
                  ),
                  DropdownSearch(
                    showSelectedItem: true,
                    maxHeight: 500,
                    mode: Mode.DIALOG,
                    items: List.generate(12, (index) => "$index"),
                    dropdownItemBuilder: (context, value, isTrue) {
                      return ListTile(
                        title: Text(DateTimeUtils.months[int.parse(value)]),
                        selected: isTrue,
                        onTap: () {
                          setState(() {
                            selectedMonth =
                                DateTimeUtils.months[int.parse(value)];
                            selectedMonthNumber = int.parse(value) + 1;
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    label: "Month",
                    onChanged: print,
                    selectedItem: selectedMonth ?? "Choose Attendance Month",
                    showSearchBox: true,
                  ),
                  SizedBox(
                    height: getDynamicHeight(50),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: getDynamicHeight(55),
                        width: getDynamicWidth(180),
                        child: GestureDetector(
                          onTap: () {
                            widget.employeeSearch(
                                selectedUserId, selectedMonthNumber);
                            Navigator.of(context).pop();
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
                                    "Search",
                                    style: activeSubTitleStyle,
                                  ),
                                )
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
        ),
      ),
    );
  }
}

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/no_data_widget.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_page.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Labour_Report/Add_report.dart';
import 'package:bhavaniconnect/home_screens/Labour_Report/Detail_Report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Print_Reports.dart';

class LabourEntries extends StatefulWidget {
  final String currentUserId;

  const LabourEntries({Key key, this.currentUserId}) : super(key: key);

  @override
  _LabourEntries createState() => _LabourEntries();
}

class _LabourEntries extends State<LabourEntries> {
  int _n = 0;

  DateTime startFilterDate = DateTimeUtils.currentDayDateTimeNow;
  DateTime endFilterDate =
      DateTimeUtils.currentDayDateTimeNow.add(Duration(days: 1));

  UserRoles userRole;

  @override
  void initState() {
    super.initState();
    getUserRoles();
  }

  getUserRoles() async {
    var prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("userRole");
    setState(() {
      userRole = userRoleValues[role];
    });
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
    var size = MediaQuery.of(context).size;
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
          rightActionBar: userRole != null &&
                  (userRole == UserRoles.Admin ||
                      userRole == UserRoles.Manager ||
                      userRole == UserRoles.Accountant ||
                      userRole == UserRoles.SiteEngineer)
              ? Icon(
                  Icons.print,
                  size: 25,
                  color: Colors.white,
                )
              : Container(height: 0, width: 0),
          rightAction: () {
            GoToPage(
                context,
                PrintReport(
                    // startDate: startFilterDate,
                    // endDate: endFilterDate,
                    ));
          },
          primaryText: 'Daily Labour Report',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: userRole != null && userRole != UserRoles.Securtiy
            ? Container(
                color: Colors.white,
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("labourReport")
                        .where("added_on", isGreaterThan: startFilterDate)
                        .where("added_on", isLessThan: endFilterDate)
                        .orderBy('added_on', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        var result = snapshot.data.documents;
                        if (result.length == 0) {
                          return NoDataWidget();
                        }
                        return ListView.builder(
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            return LabourEntry(
                              size,
                              context,
                              result[index].documentID,
                              DateTimeUtils.dayMonthYearTimeFormat(
                                  (result[index]['added_on'] as Timestamp)
                                      .toDate()),
                              result[index]['construction_site']
                                  ['constructionSite'],
                              result[index]['labour_type'],
                              result[index]['block']['blockName'],
                              result[index]['purpose'],
                              result[index]['dealer']['dealerName'],
                              topPadding: index == 0 ? 40 : 20,
                            );
                          },
                        );
                      }
                    }),
              )
            : OfflinePage(
                text: "you don’t have access\nto this page",
                color: Colors.white,
              ),
      ),
      floatingActionButton: userRole != null &&
              (userRole == UserRoles.Admin ||
                  userRole == UserRoles.SiteEngineer ||
                  userRole == UserRoles.Manager)
          ? FloatingActionButton(
              onPressed: () {
                GoToPage(
                  context,
                  AddLabourReport(
                    currentUserId: widget.currentUserId,
                  ),
                );
              },
              child: Icon(Icons.add),
              backgroundColor: backgroundColor,
            )
          : null,
    );
  }
}

class ItemInfo {
  String slNo;
  String createdBy;
  String date;
  String site;
  String block;
  String labourType;
  String dealerName;
  String noofPeople;
  String purpose;

  ItemInfo({
    this.slNo,
    this.createdBy,
    this.date,
    this.site,
    this.block,
    this.labourType,
    this.dealerName,
    this.noofPeople,
    this.purpose,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Self employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"),
  ItemInfo(
      slNo: '2',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Out Sourcing employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      createdBy: "Vasanth (Manager)",
      labourType: "Self employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"),
  ItemInfo(
      slNo: '4',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Out Sourcing employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"),
  ItemInfo(
      slNo: '5',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Self employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"),
];

Widget LabourEntry(
    Size size,
    BuildContext context,
    String documentId,
    String date,
    String site,
    String labourType,
    String block,
    String purpose,
    String dealerName,
    {double topPadding = 20.0}) {
  return GestureDetector(
    onTap: () {
      GoToPage(context, DetailReport());
    },
    child: Padding(
      padding: EdgeInsets.only(right: 15.0, left: 15, top: topPadding),
      child: Container(
        width: double.infinity,
        height: 210,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 15,
              top: 0,
              child: Text(date, style: descriptionStyleDarkBlur3),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 24,
                  top: 24,
                  right: size.width * .35,
                ),
                height: 185,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA).withOpacity(.45),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(site, style: subTitleStyle1),
                    SizedBox(height: 10),
                    Text(
                      "Block: $block",
                      style: descriptionStyleDarkBlur1,
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Text(labourType,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleStyleDark1),
                    ),
                    SizedBox(height: 10),
                    Text(dealerName, style: subTitleStyle),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: SizedBox(
            //     height: 50,
            //     width: size.width * .40,
            //     child: Container(
            //       alignment: Alignment.center,
            //       padding: EdgeInsets.symmetric(vertical: 10),
            //       decoration: BoxDecoration(
            //         color: backgroundColor,
            //         borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(24),
            //           bottomRight: Radius.circular(24),
            //         ),
            //       ),
            //       child: Text(purpose, style: subTitleStyleLight),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
}

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Add_Progress&Remarks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class EntryDescription extends StatefulWidget {
  final String currentUserId;
  final String documentId;

  const EntryDescription({Key key, this.currentUserId, this.documentId})
      : super(key: key);

  @override
  _EntryDescription createState() => _EntryDescription();
}

class _EntryDescription extends State<EntryDescription> {
  int index = 0;
  int totalProgress = 0;

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
            primaryText: 'Entry Details',
            tabBarWidget: null,
          ),
        ),
        body: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
          child: Container(
              color: Colors.white,
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection(AppConstants.prod + "concreteEntries")
                    .orderBy('added_on', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    var result = snapshot.data.documents;
                    return SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                subtext(
                                    "Created On",
                                    DateTimeUtils.slashDateFormat(
                                        (result[0]['added_on'] as Timestamp)
                                            .toDate())),
                                subtext(
                                    "Selected Date",
                                    DateTimeUtils.slashDateFormat((result[0]
                                            ['selected_date'] as Timestamp)
                                        .toDate())),
                                subtext("Created By",
                                    "${result[0]['created_by']['name']}  (${result[0]['created_by']['role']})"),
                                subtext(
                                    "Site",
                                    result[0]['construction_site']
                                        ['constructionSite']),
                                subtext(
                                    "Block", result[0]['block']['blockName']),
                                subtext(
                                    "Concrete Type",
                                    result[0]['concrete_type']
                                        ['concreteTypeName']),
                                Divider(
                                  thickness: 1,
                                  color: Colors.black45,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: StreamBuilder(
                                      stream: Firestore.instance
                                          .collection(AppConstants.prod +
                                              "activityProgress")
                                          .document(widget.documentId)
                                          .collection(widget.documentId)
                                          // .orderBy('added_on',
                                          //     descending: false)
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        index = 0;
                                        totalProgress = 0;
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          var result = snapshot.data.documents;
                                          print(result);
                                          if (result != null &&
                                              result.length > 0) {
                                            return DataTable(
                                              onSelectAll: (b) {},
                                              sortAscending: true,
                                              showCheckboxColumn: false,
                                              dataRowHeight: getDynamicHeight(70),
                                              columns: <DataColumn>[
                                                DataColumn(
                                                    label: Text(
                                                  "S.No.",
                                                  style: subTitleStyle1,
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  "Date",
                                                  style: subTitleStyle1,
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  "Yesterday’s\nProgress",
                                                  style: subTitleStyle1,
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  "Total\nProgress",
                                                  style: subTitleStyle1,
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  "Added By",
                                                  style: subTitleStyle1,
                                                )),
                                                DataColumn(
                                                    label: Text(
                                                  "Remarks",
                                                  style: subTitleStyle1,
                                                )),
                                              ],
                                              rows: result.map((row) {
                                                index++;
                                                print(
                                                    row['yesterday_progress']);
                                                totalProgress += int.parse(
                                                    row['yesterday_progress']);
                                                ItemInfo itemRow = ItemInfo(
                                                  slNo: index.toString(),
                                                  date: DateTimeUtils
                                                      .formatDayMonthYear(
                                                          (row['added_on']
                                                                  as Timestamp)
                                                              .toDate()),
                                                  yestProg:
                                                      row['yesterday_progress']
                                                          .toString(),
                                                  totalprog:
                                                      totalProgress.toString(),
                                                  addedBy:
                                                      "${row['created_by']['name']}  (${row['created_by']['role']})",
                                                  remarks:
                                                      row['remark'].toString(),
                                                );
                                                return DataRow(
                                                  onSelectChanged: (b) {},
                                                  cells: [
                                                    DataCell(
                                                      Text(
                                                        itemRow.slNo,
                                                        style:
                                                            descriptionStyleDark,
                                                      ),
                                                      showEditIcon: false,
                                                      placeholder: false,
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        itemRow.date,
                                                        style:
                                                            descriptionStyleDark,
                                                      ),
                                                      showEditIcon: false,
                                                      placeholder: false,
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        itemRow.yestProg,
                                                        style:
                                                            descriptionStyleDark,
                                                      ),
                                                      showEditIcon: false,
                                                      placeholder: false,
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        itemRow.totalprog,
                                                        style:
                                                            descriptionStyleDark,
                                                      ),
                                                      showEditIcon: false,
                                                      placeholder: false,
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        itemRow.addedBy,
                                                        style:
                                                            descriptionStyleDark,
                                                      ),
                                                      showEditIcon: false,
                                                      placeholder: false,
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        itemRow.remarks,
                                                        style:
                                                            descriptionStyleDark,
                                                      ),
                                                      showEditIcon: false,
                                                      placeholder: false,
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            );
                                          }
                                          return Container(
                                            child: Center(
                                              child: Text(
                                                "No Data Available",
                                                style: descriptionStyleDark,
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.black45,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Remarks:",
                                        style: subTitleStyle,
                                      ),
                                      SizedBox(
                                        height: getDynamicHeight(5),
                                      ),
                                      Text(
                                        "Transfer from store to construction site",
                                        style: descriptionStyleDarkBlur1,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: getDynamicHeight(500),
                          ),
                        ]));
                  }
                },
              )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: userRole != null &&
                (userRole == UserRoles.Admin ||
                    userRole == UserRoles.Manager ||
                    userRole == UserRoles.StoreManager)
            ? Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        GoToPage(
                            context,
                            AddProgressRemarks(
                              currentUserId: widget.currentUserId,
                              documentId: widget.documentId,
                              tableName: AppConstants.prod + "concreteEntries",
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: backgroundColor,
                        ),
                        height: getDynamicHeight(40),
                        width: getDynamicWidth(90),
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
              )
            : null);
  }
}

Widget subtext(String _left, String _right) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('$_left :', style: subTitleStyle),
        Text('$_right', style: descriptionStyleDarkBlur1),
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
        Text('$_left :', style: titleStyle),
        Text('$_right', style: highlight),
      ],
    ),
  );
}

class ItemInfo {
  String slNo;
  String date;
  String yestProg;
  String totalprog;
  String addedBy;
  String remarks;

  ItemInfo({
    this.slNo,
    this.date,
    this.yestProg,
    this.totalprog,
    this.addedBy,
    this.remarks,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '2',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '4',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '5',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'),
];

import 'dart:io';
import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class PrintDailyAttendance extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String selectedConstructionId;
  final String selectedConstructionSite;
  final String selectedUserId;
  final String selectedUser;
  const PrintDailyAttendance(
    this.startDate,
    this.endDate,
    this.selectedConstructionId,
    this.selectedConstructionSite,
    this.selectedUserId,
    this.selectedUser,
  );

  @override
  _PrintDailyAttendance createState() => _PrintDailyAttendance();
}

class _PrintDailyAttendance extends State<PrintDailyAttendance> {
  int index = 0;

  @override
  void initState() {
    super.initState();
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
    Size size = MediaQuery.of(context).size;
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
          rightActionBar: Icon(Icons.print, size: 25, color: Colors.white),
          rightAction: () {
            _generateCSVAndView(context);
          },
          primaryText: 'Daily Attendance',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: getDynamicHeight(20),
                ),
                Column(
                  children: [
                    Text(
                      "${DateTimeUtils.dayMonthFormat(widget.startDate)} to ${DateTimeUtils.dayMonthFormat(widget.endDate)}",
                      style: subTitleStyleDark1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.selectedConstructionSite ?? 'All'} | ${widget.selectedUser ?? 'All'}",
                      // "ConstructionSite | Dealer | Category",
                      style: descriptionStyleDarkBlur1,
                    ),
                  ],
                ),
                SizedBox(
                  height: getDynamicHeight(40),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection(AppConstants.prod + "attendance")
                        .where("construction_site.constructionId",
                            isEqualTo: widget.selectedConstructionId)
                        .where('created_by.id',
                            isEqualTo: widget.selectedUserId)
                        .where("punch_in", isGreaterThan: widget.startDate)
                        .where("punch_in", isLessThan: widget.endDate)
                        .orderBy('punch_in', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      index = 0;
                      if (!snapshot.hasData) {
                        return Container(
                            child: Center(child: CircularProgressIndicator()),
                            width: size.width);
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error),
                        );
                      } else {
                        List<DocumentSnapshot> result = snapshot.data.documents;

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
                              "In Time",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Out Time",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Total Time",
                              style: subTitleStyle1,
                            )),
                          ],
                          rows: result.map((item) {
                            index++;

                            ItemInfo itemRow = ItemInfo(
                              slNo: index.toString(),
                              date: DateTimeUtils.slashDateFormat(
                                  (item['punch_in'] as Timestamp).toDate()),
                              site:
                                  "${item['construction_site']['constructionSite']}",
                              inTime: DateTimeUtils.hourMinuteFormat(
                                  (item['punch_in'] as Timestamp).toDate()),
                              outTime: DateTimeUtils.hourMinuteFormat(
                                  (item['punch_out'] as Timestamp).toDate()),
                              totalTime: DateTimeUtils.getDifferenceTime(
                                  (item['punch_in'] as Timestamp).toDate(),
                                  (item['punch_out'] as Timestamp).toDate()),
                            );
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    itemRow.slNo,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.date,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.inTime,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.outTime,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.totalTime,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
                // --------------- /////////////////////
                SizedBox(
                  height: getDynamicHeight(500),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _generateCSVAndView(context) async {
    QuerySnapshot data = await Firestore.instance
        .collection(AppConstants.prod + "attendance")
        .where("construction_site.constructionId",
            isEqualTo: widget.selectedConstructionId)
        .where('created_by.id', isEqualTo: widget.selectedUserId)
        .where("punch_in", isGreaterThan: widget.startDate)
        .where("punch_in", isLessThan: widget.endDate)
        .orderBy('punch_in', descending: true)
        .getDocuments();
    int i = 0;
    List<List<String>> csvData = [
      // headers
      <String>[
        'S.No.',
        'Date',
        'In Time',
        "Out Time",
        "Total Time",
      ],
      // data
      ...data.documents.map((result) {
        i++;
        return [
          i.toString(),
          DateTimeUtils.slashDateFormat(
              (result['punch_in'] as Timestamp).toDate()),
          DateTimeUtils.hourMinuteFormat(
              (result['punch_in'] as Timestamp).toDate()),
          DateTimeUtils.hourMinuteFormat(
              (result['punch_out'] as Timestamp).toDate()),
          DateTimeUtils.getDifferenceTime(
              (result['punch_in'] as Timestamp).toDate(),
              (result['punch_out'] as Timestamp).toDate()),
        ];
      }),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/filteredVehicles.csv';

    // create file
    final File file = File(path);
    // Save csv string using default configuration
    // , as field separator
    // " as text delimiter and
    // \r\n as eol.
    await file.writeAsString(csv);

    shareFile(path);
  }

  shareFile(String path) async {
    ShareExtend.share(path, "file");
  }
}

class ItemInfo {
  String slNo;
  String date;
  String site;
  String name;
  String inTime;
  String outTime;
  String totalTime;

  ItemInfo({
    this.slNo,
    this.date,
    this.name,
    this.site,
    this.inTime,
    this.outTime,
    this.totalTime,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      name: "Vasanth",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      inTime: "10:30am",
      outTime: "6:45pm",
      totalTime: "7hrs")
];

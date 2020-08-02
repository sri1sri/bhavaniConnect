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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class PrintMonthlyAttendance extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String selectedConstructionId;
  final String selectedConstructionSite;
  final String selectedUserId;
  final String selectedUser;
  const PrintMonthlyAttendance(
    this.startDate,
    this.endDate,
    this.selectedConstructionId,
    this.selectedConstructionSite,
    this.selectedUserId,
    this.selectedUser,
  );

  @override
  _PrintMonthlyAttendance createState() => _PrintMonthlyAttendance();
}

class _PrintMonthlyAttendance extends State<PrintMonthlyAttendance> {
  int index = 0;

  Map<DateTime, int> newMonthAttendance = {};
  Map<DateTime, int> holidayMonthAttendance = {};

  Map<DateTime, int> printMonthAttendance = {};
  Map<DateTime, int> printHolidayAttendance = {};

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
          primaryText: 'Monthly Attendance',
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
                        print(result.length);
                        print(result.length);
                        for (int i = 0; i < result.length; i++) {
                          int month = (result[i].data['punch_in'] as Timestamp)
                              .toDate()
                              .month;

                          int year = (result[i].data['punch_in'] as Timestamp)
                              .toDate()
                              .year;

                          print("year");
                          print(year);
                          print(year);
                          print(year);
                          print(month);
                          if (newMonthAttendance[DateTime(year, month, 1)] !=
                              null) {
                            newMonthAttendance[DateTime(year, month, 1)] =
                                newMonthAttendance[DateTime(year, month, 1)] +
                                    1;
                          } else {
                            newMonthAttendance[DateTime(year, month, 1)] = 1;

                            for (int j = 1;
                                j <= DateTimeUtils.daysInMonth(month, year);
                                j++) {
                              DateTime date = DateTime(year, month, j);

                              if (DateFormat('EEEE').format(date) == "Sunday") {
                                if (holidayMonthAttendance[
                                        DateTime(year, month, 1)] !=
                                    null) {
                                  holidayMonthAttendance[
                                          DateTime(year, month, 1)] =
                                      holidayMonthAttendance[
                                              DateTime(year, month, 1)] +
                                          1;
                                } else {
                                  holidayMonthAttendance[
                                      DateTime(year, month, 1)] = 1;
                                }
                              }
                            }
                          }
                        }

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
                              "Month & Year",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "No. of Days Worked",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "No. of Days leave",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "No. of Holidays",
                              style: subTitleStyle1,
                            )),
                          ],
                          rows: newMonthAttendance.keys.map((item) {
                            index++;

                            ItemInfo itemRow = ItemInfo(
                                slNo: index.toString(),
                                date: DateTimeUtils.formatMonthYear((item)),
                                site: "",
                                name: "",
                                present: newMonthAttendance[item].toString(),
                                absent: (DateTimeUtils.daysInMonth(
                                            item.month, item.year) -
                                        holidayMonthAttendance[item] -
                                        newMonthAttendance[item])
                                    .toString(),
                                holidays:
                                    holidayMonthAttendance[item].toString());
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
                                    itemRow.present,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.absent,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.holidays,
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
                // ----------------------
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

    for (int i = 0; i < data.documents.length; i++) {
      int month =
          (data.documents[i].data['punch_in'] as Timestamp).toDate().month;

      int year =
          (data.documents[i].data['punch_in'] as Timestamp).toDate().year;

      if (printMonthAttendance[DateTime(year, month, 1)] != null) {
        printMonthAttendance[DateTime(year, month, 1)] =
            printMonthAttendance[DateTime(year, month, 1)] + 1;
      } else {
        printMonthAttendance[DateTime(year, month, 1)] = 1;

        for (int j = 1; j <= DateTimeUtils.daysInMonth(month, year); j++) {
          DateTime date = DateTime(year, month, j);

          if (DateFormat('EEEE').format(date) == "Sunday") {
            if (printHolidayAttendance[DateTime(year, month, 1)] != null) {
              printHolidayAttendance[DateTime(year, month, 1)] =
                  printHolidayAttendance[DateTime(year, month, 1)] + 1;
            } else {
              printHolidayAttendance[DateTime(year, month, 1)] = 1;
            }
          }
        }
      }
    }

    List<List<String>> csvData = [
      // headers
      <String>[
        'S.No.',
        "Month & Year",
        "No. of Days Worked",
        "No. of Days leave",
        "No. of Holidays",
      ],
      // data
      ...printMonthAttendance.keys.map((result) {
        i++;
        return [
          i.toString(),
          DateTimeUtils.formatMonthYear((result)),
          printMonthAttendance[result].toString(),
          (DateTimeUtils.daysInMonth(result.month, result.year) -
                  printHolidayAttendance[result] -
                  printMonthAttendance[result])
              .toString(),
          holidayMonthAttendance[result].toString(),
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
  String present;
  String absent;
  String holidays;

  ItemInfo({
    this.slNo,
    this.date,
    this.name,
    this.site,
    this.present,
    this.absent,
    this.holidays,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      name: "Vasanth",
      date: 'Oct-2020',
      site: 'Bhavani Vivan',
      present: "22 days",
      absent: "3 days")
];

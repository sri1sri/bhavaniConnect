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

class PrintMonthlyAttendance extends StatefulWidget {

  @override
  _PrintMonthlyAttendance  createState() => _PrintMonthlyAttendance ();
}

class _PrintMonthlyAttendance  extends State<PrintMonthlyAttendance> {
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
            // _generateCSVAndView(context);
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
                      "Oct 2020 to Dec 2020",
                      style: subTitleStyleDark1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Construction Site",
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          " | ",
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          "Employee Name",
                          style: descriptionStyleDarkBlur2,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: getDynamicHeight(40),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
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
//                      DataColumn(
//                          label: Text(
//                            "Employee name",
//                            style: subTitleStyle1,
//                          )),
//                      DataColumn(
//                          label: Text(
//                            "Construction Site",
//                            style: subTitleStyle1,
//                          )),
                      DataColumn(
                          label: Text(
                            "No. of Days Worked",
                            style: subTitleStyle1,
                          )),
                      DataColumn(
                          label: Text(
                            "No. of Days laeave",
                            style: subTitleStyle1,
                          )),
                    ],
                    rows: items
                        .map(
                          (itemRow) => DataRow(
                        cells: [
                          DataCell(
                            Text(itemRow.slNo,style: descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(itemRow.date,style: descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
//                          DataCell(
//                            Text(itemRow.name,style: descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.site,style: descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
                          DataCell(
                            Text(itemRow.present,style: descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(itemRow.absent,style: descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
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

//  Future<void> _generateCSVAndView(context) async {
//    QuerySnapshot data = await Firestore.instance
//        .collection(AppConstants.prod + "concreteEntries")
//        .where("construction_site.constructionId",
//        isEqualTo: widget.constructionId)
//        .where('concrete_type.concreteTypeId', isEqualTo: widget.concreteTypeId)
//        .where("block.blockId", isEqualTo: widget.blockId)
//        .where("added_on", isGreaterThan: widget.startDate)
//        .where("added_on", isLessThan: widget.endDate)
//        .orderBy('added_on', descending: true)
//        .getDocuments();
//    int i = 0;
//    List<List<String>> csvData = [
//      // headers
//      <String>[
//        'S.No.',
//        'Created On',
//        'Created By',
//        "Site",
//        "Block",
//        "Total Progress",
//        "Remarks"
//      ],
//      // data
//      ...data.documents.map((result) {
//        i++;
//        return [
//          i.toString(),
//          DateTimeUtils.slashDateFormat(
//              (result['added_on'] as Timestamp).toDate()),
//          "${result['created_by']['name']}  (${result['created_by']['role']})",
//          result['construction_site']['constructionSite'],
//          result['block']['blockName'],
//          result['total_progress'],
//          result['remark'],
//        ];
//      }),
//    ];
//
//    String csv = const ListToCsvConverter().convert(csvData);
//
//    final String dir = (await getApplicationDocumentsDirectory()).path;
//    final String path = '$dir/siteActivitiesDocs.csv';
//
//    // create file
//    final File file = File(path);
//    // Save csv string using default configuration
//    // , as field separator
//    // " as text delimiter and
//    // \r\n as eol.
//    await file.writeAsString(csv);
//
//    shareFile(path);
//  }

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

  ItemInfo({
    this.slNo,
    this.date,
    this.name,
    this.site,
    this.present,
    this.absent,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      name: "Vasanth",
      date: 'Oct-2020',
      site: 'Bhavani Vivan',
      present: "22 days",
      absent: "3 days"
  )

];

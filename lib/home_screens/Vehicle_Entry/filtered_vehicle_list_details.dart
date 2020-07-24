import 'dart:io';

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class VehicleDataList extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String selectedConstructionId;
  final String selectedConstructionSite;
  final String selectedDealerId;
  final String selectedDealer;

  const VehicleDataList(
    this.startDate,
    this.endDate,
    this.selectedConstructionId,
    this.selectedConstructionSite,
    this.selectedDealerId,
    this.selectedDealer,
  );
  @override
  _VehicleDataList createState() => _VehicleDataList();
}

class _VehicleDataList extends State<VehicleDataList> {
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
          primaryText: 'Vehicle Entries',
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
            children: [
              SizedBox(
                height: getDynamicHeight(20),
              ),
              Text(
                // "$sDate",
                "${DateTimeUtils.dayMonthFormat(widget.startDate)} to ${DateTimeUtils.dayMonthFormat(widget.endDate)}",
                style: subTitleStyleDark1,
              ),
              Text(
                "${widget.selectedConstructionSite ?? 'All'} | ${widget.selectedDealer ?? 'All'}",
                // "Vasanth Motors | Bhavani Vivan",
                style: descriptionStyleDarkBlur1,
              ),
              SizedBox(
                height: getDynamicHeight(20),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(AppConstants.prod + "vehicleEntries")
                      .where("construction_site.constructionId",
                          isEqualTo: widget.selectedConstructionId)
                      .where('dealer.dealerId',
                          isEqualTo: widget.selectedDealerId)
                      .where('status', isEqualTo: "Approved")
                      .where("added_on", isGreaterThan: widget.startDate)
                      .where("added_on", isLessThan: widget.endDate)
                      .orderBy('added_on', descending: true)
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
                            "Vehicle Number",
                            style: subTitleStyle1,
                          )),
                          DataColumn(
                              label: Text(
                            "Site",
                            style: subTitleStyle1,
                          )),
                          DataColumn(
                              label: Text(
                            "Dealer Name",
                            style: subTitleStyle1,
                          )),
                          // DataColumn(
                          //   label: Text(
                          //     "Category",
                          //     style: subTitleStyle1,
                          //   ),
                          // ),
                          DataColumn(
                            label: Text(
                              "Vehicle Type",
                              style: subTitleStyle1,
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Vehicle Name",
                              style: subTitleStyle1,
                            ),
                          ),
                          DataColumn(
                              label: Text(
                            "Start Time",
                            style: subTitleStyle1,
                          )),
                          DataColumn(
                              label: Text(
                            "Start Readings",
                            style: subTitleStyle1,
                          )),
                          DataColumn(
                              label: Text(
                            "End Time",
                            style: subTitleStyle1,
                          )),
                          DataColumn(
                              label: Text(
                            "End Readings",
                            style: subTitleStyle1,
                          )),
                          DataColumn(
                              label: Text(
                            "Total Timings",
                            style: subTitleStyle1,
                          )),
                          DataColumn(
                              label: Text(
                            "Total Reading",
                            style: subTitleStyle1,
                          )),
                          DataColumn(
                              label: Text(
                            "Total Trips",
                            style: subTitleStyle1,
                          )),
                          DataColumn(
                              label: Text(
                            "Units per Trip",
                            style: subTitleStyle1,
                          )),
                        ],
                        rows: result.map((item) {
                          index++;
                          ItemInfo itemRow = ItemInfo(
                            slNo: index.toString(),
                            date: DateTimeUtils.slashDateFormat(
                                (item['added_on'] as Timestamp).toDate()),
                            vehicleNo: item['vehicleNumber'],
                            site: item['construction_site']['constructionSite'],
                            delName: item['dealer']['dealerName'],
                            vehicleType: item['vehicleType'],
                            startTime: item['startTime'] != null
                                ? DateTimeUtils.hourMinuteFormat(
                                    (item['startTime'] as Timestamp).toDate())
                                : '-',
                            startRead: item['startRead'] != null
                                ? item['startRead'].toString()
                                : '-',
                            endTime: item['endTime'] != null
                                ? DateTimeUtils.hourMinuteFormat(
                                    (item['endTime'] as Timestamp).toDate())
                                : '-',
                            endRead: item['endRead'] != null
                                ? item['endRead'].toString()
                                : '-',
                            totalTime: item['startTime'] != null &&
                                    item['endTime'] != null
                                ? DateTimeUtils.getDifferenceTime(
                                    (item['startTime'] as Timestamp).toDate(),
                                    (item['endTime'] as Timestamp).toDate(),
                                  )
                                : "-",
                            totalRead: item['startRead'] != null &&
                                    item['endRead'] != null
                                ? (int.parse(item['startRead']) -
                                        int.parse(item['endRead']))
                                    .toString()
                                : "-",
                            totalTrips: item['timeRecords'] != null
                                ? item['timeRecords'].length.toString()
                                : '',
                            unitsPerTrip: item['unitsPerTrip'] != null
                                ? item['unitsPerTrip']
                                : '',
                          );

                          return DataRow(
                            onSelectChanged: (b) {},
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
                                  itemRow.vehicleNo,
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  itemRow.site,
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  itemRow.delName,
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  itemRow.vehicleType,
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  "Tractor",
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  itemRow.startTime,
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  itemRow.startRead,
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  itemRow.endTime,
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  itemRow.endRead,
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
                              DataCell(
                                Text(
                                  itemRow.totalRead,
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  itemRow.totalTrips,
                                  style: descriptionStyleDark,
                                ),
                                showEditIcon: false,
                                placeholder: false,
                              ),
                              DataCell(
                                Text(
                                  itemRow.unitsPerTrip,
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
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: DataTable(
              //     onSelectAll: (b) {},
              //     sortAscending: true,
              //     showCheckboxColumn: false,
              //     dataRowHeight: 90.0,
              //     columns: <DataColumn>[
              //       DataColumn(
              //           label: Text(
              //         "S.No.",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "Date",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "Vehicle Number",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "Site",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "Dealer Name",
              //         style: subTitleStyle1,
              //       )),
              //       // DataColumn(
              //       //   label: Text(
              //       //     "Category",
              //       //     style: subTitleStyle1,
              //       //   ),
              //       // ),
              //       DataColumn(
              //         label: Text(
              //           "Vehicle Type",
              //           style: subTitleStyle1,
              //         ),
              //       ),
              //       DataColumn(
              //           label: Text(
              //         "Start Time",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "Start Readings",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "End Time",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "End Readings",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "Total Timings",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "Total Reading",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "Total Trips",
              //         style: subTitleStyle1,
              //       )),
              //       DataColumn(
              //           label: Text(
              //         "Units per Trip",
              //         style: subTitleStyle1,
              //       )),
              //     ],
              //     rows: items
              //         .map(
              //           (itemRow) => DataRow(
              //             cells: [
              //               DataCell(
              //                 Text(
              //                   itemRow.slNo,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.date,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.vehicleNo,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.site,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.delName,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               // DataCell(
              //               //   Text(
              //               //     itemRow.nameCat,
              //               //     style: descriptionStyleDark,
              //               //   ),
              //               //   showEditIcon: false,
              //               //   placeholder: false,
              //               // ),
              //               DataCell(
              //                 Text(
              //                   itemRow.vehicleType,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.startTime,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.startRead,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.endTime,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.endRead,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.totalTime,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.totalRead,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.totalTrips,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //               DataCell(
              //                 Text(
              //                   itemRow.unitsPerTrip,
              //                   style: descriptionStyleDark,
              //                 ),
              //                 showEditIcon: false,
              //                 placeholder: false,
              //               ),
              //             ],
              //           ),
              //         )
              //         .toList(),
              //   ),
              // ),

            ],
          )),
        ),
      ),
    );
  }

  Future<void> _generateCSVAndView(context) async {
    QuerySnapshot data = await Firestore.instance
        .collection(AppConstants.prod + "vehicleEntries")
        .where("construction_site.constructionId",
            isEqualTo: widget.selectedConstructionId)
        .where("dealer.dealerId", isEqualTo: widget.selectedDealerId)
        .where('status', isEqualTo: "Approved")
        .where("added_on", isGreaterThan: widget.startDate)
        .where("added_on", isLessThan: widget.endDate)
        .orderBy('added_on', descending: true)
        .getDocuments();
    int i = 0;
    List<List<String>> csvData = [
      // headers
      <String>[
        'S.No.',
        'Date',
        'Vehicle Number',
        "Site",
        "Dealer Name",
        "Vehicle Type",
        "Start Time",
        "Start Readings",
        "End Time",
        "End Readings",
        "Total Timings",
        "Total Reading",
        "Total Trips",
        "Units per Trip",
      ],
      // data
      ...data.documents.map((result) {
        i++;
        return [
          i.toString(),
          DateTimeUtils.slashDateFormat(
              (result['added_on'] as Timestamp).toDate()),
          "${result['created_by']['name']}  (${result['created_by']['role']})",
          result['vehicleNumber'],
          result['construction_site']['constructionSite'],
          result['dealer']['dealerName'],
          result['startTime'] != null
              ? DateTimeUtils.hourMinuteFormat(
                  (result['startTime'] as Timestamp).toDate())
              : '-',
          result['startRead'] != null ? result['startRead'].toString() : '-',
          result['endTime'] != null
              ? DateTimeUtils.hourMinuteFormat(
                  (result['endTime'] as Timestamp).toDate())
              : 'null',
          result['endRead'] != null ? result['endRead'].toString() : '-',
          result['startTime'] != null && result['endTime'] != null
              ? DateTimeUtils.getDifferenceTime(
                  (result['startTime'] as Timestamp).toDate(),
                  (result['endTime'] as Timestamp).toDate(),
                )
              : "-",
          result['startRead'] != null && result['endRead'] != null
              ? (int.parse(result['startRead']) - int.parse(result['endRead']))
                  .toString()
              : "-",
          result['timeRecords'] != null
              ? result['timeRecords'].length.toString()
              : '',
          result['unitsPerTrip'] != null ? result['unitsPerTrip'] : '',
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
  String vehicleNo;
  String site;
  String delName;
  // String nameCat;
  String vehicleType;
  String startTime;
  String startRead;
  String endTime;
  String endRead;
  String totalTime;
  String totalRead;
  String totalTrips;
  String unitsPerTrip;
  String requestedBy;
  String approvedBy;
  String approvalStatus;

  ItemInfo({
    this.slNo,
    this.date,
    this.vehicleNo,
    this.site,
    this.delName,
    // this.nameCat,
    this.vehicleType,
    this.startTime,
    this.startRead,
    this.endTime,
    this.endRead,
    this.totalTime,
    this.totalRead,
    this.totalTrips,
    this.unitsPerTrip,
    this.requestedBy,
    this.approvedBy,
    this.approvalStatus,
  });
}

// var items = <ItemInfo>[
//   ItemInfo(
//     slNo: '1',
//     date: '29/10/2020',
//     vehicleNo: 'TN66V6571',
//     site: 'Bhavani Vivan',
//     delName: 'Vasanth Motors',
//     // nameCat: 'JCB/Hitachi',
//     vehicleType: 'Trip',
//     startTime: '10.30am',
//     startRead: '8723711',
//     endTime: '06.34pm',
//     endRead: '3838282',
//     totalTime: '3hrs',
//     totalRead: '7677',
//     totalTrips: '10',
//     unitsPerTrip: '3',
//     requestedBy: 'Vasanth (Supervisor)',
//     approvedBy: 'Srivatsav (Manager)',
//     approvalStatus: 'Approved',
//   ),
//   ItemInfo(
//     slNo: '2',
//     date: '30/10/2020',
//     vehicleNo: 'TN33V6371',
//     site: 'Bhavani Aravindham',
//     delName: 'Sri motors',
//     // nameCat: 'Tractor',
//     vehicleType: 'Trip',
//     startTime: '10.30am',
//     startRead: '8723711',
//     endTime: '06.34pm',
//     endRead: '3838282',
//     totalTime: '3hrs',
//     totalRead: '7677',
//     totalTrips: '10',
//     unitsPerTrip: '3',
//     requestedBy: 'Vasanth (Supervisor)',
//     approvedBy: 'Srivatsav (Manager)',
//     approvalStatus: 'Declined',
//   ),
//   ItemInfo(
//     slNo: '3',
//     date: '04/04/2020',
//     vehicleNo: 'TN66V6571',
//     site: 'Bhavani Vivan',
//     delName: 'Vasanth Motors',
//     // nameCat: 'Road Roller',
//     vehicleType: 'Trip',
//     startTime: '10.30am',
//     startRead: '8723711',
//     endTime: '06.34pm',
//     endRead: '3838282',
//     totalTime: '3hrs',
//     totalRead: '7677',
//     totalTrips: '10',
//     unitsPerTrip: '3',
//     requestedBy: 'Vasanth (Supervisor)',
//     approvedBy: 'Srivatsav (Manager)',
//     approvalStatus: 'Pending',
//   ),
//   ItemInfo(
//     slNo: '4',
//     date: '20/12/2020',
//     vehicleNo: 'TN66V6571',
//     site: 'Bhavani Vivan',
//     delName: 'Vasanth Motors',
//     // nameCat: 'BoreWell',
//     vehicleType: 'Trip',
//     startTime: '10.30am',
//     startRead: '8723711',
//     endTime: '06.34pm',
//     endRead: '3838282',
//     totalTime: '3hrs',
//     totalRead: '7677',
//     totalTrips: '10',
//     unitsPerTrip: '3',
//     requestedBy: 'Vasanth (Supervisor)',
//     approvedBy: 'Srivatsav (Manager)',
//     approvalStatus: 'Approved',
//   ),
// ];

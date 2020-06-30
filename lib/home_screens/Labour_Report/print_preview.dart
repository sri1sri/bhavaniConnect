import 'dart:io';

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class PrintPreviewLabour extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String constructionId;
  final String constructionSite;
  final String dealerId;
  final String dealerName;
  final String blockId;
  final String blockName;
  final String labourType;

  const PrintPreviewLabour(
      this.startDate,
      this.endDate,
      this.constructionId,
      this.constructionSite,
      this.dealerId,
      this.dealerName,
      this.blockId,
      this.blockName,
      this.labourType);

  @override
  _PrintPreviewLabour createState() => _PrintPreviewLabour();
}

class _PrintPreviewLabour extends State<PrintPreviewLabour> {
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firestore.instance
        .collection(AppConstants.prod + "labourReport")
        .where("construction_site.constructionId",
            isEqualTo: widget.constructionId)
        .where('labour_type', isEqualTo: widget.labourType)
        .where("block.blockId", isEqualTo: widget.blockId)
        .where("dealer.dealerId", isEqualTo: widget.dealerId)
        .where("added_on", isGreaterThan: widget.startDate)
        .where("added_on", isLessThan: widget.endDate)
        .orderBy('added_on', descending: true)
        .getDocuments();
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
            _generateCSVAndView(context);
          },
          primaryText: 'Print Preview',
          tabBarWidget: null,
        ),
      ),
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
                  height: getDynamicHeight(20),
                ),
                Column(
                  children: [
                    Text(
                      "${DateTimeUtils.dayMonthFormat(widget.startDate)} to ${DateTimeUtils.dayMonthFormat(widget.endDate)}",
                      style: subTitleStyleDark1,
                    ),
                    SizedBox(
                      height: getDynamicHeight(5),
                    ),
                    Text(
                      "${widget.constructionSite ?? 'All'} (${widget.blockName ?? 'All'})",
                      style: descriptionStyleDarkBlur2,
                    ),
                    SizedBox(
                      height: getDynamicHeight(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.labourType ?? 'All',
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          " | ",
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          widget.dealerName ?? 'All',
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
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection(AppConstants.prod + "labourReport")
                        .where("construction_site.constructionId",
                            isEqualTo: widget.constructionId)
                        .where('labour_type', isEqualTo: widget.labourType)
                        .where("block.blockId", isEqualTo: widget.blockId)
                        .where("dealer.dealerId", isEqualTo: widget.dealerId)
                        .where("selected_date", isGreaterThan: widget.startDate)
                        .where("selected_date", isLessThan: widget.endDate)
                        .orderBy('selected_date', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      index = 0;
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
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
                              "Created On",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Created By",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Labour Type",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Construction Site",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Block",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Dealer Name",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "No. of People",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                              label: Text(
                                "Propose",
                                style: subTitleStyle1,
                              ),
                            ),
                          ],
                          rows: result.map((item) {
                            index++;

                            ItemInfo itemRow = ItemInfo(
                                slNo: index.toString(),
                                date: DateTimeUtils.slashDateFormat(
                                    (item['added_on'] as Timestamp).toDate()),
                                site: item['construction_site']
                                    ['constructionSite'],
                                block: item['block']["blockName"],
                                labourType: item['labour_type'],
                                dealerName: item['dealer']['dealerName'],
                                noofPeople: item['no_of_people'],
                                createdBy:
                                    "${item['created_by']['name']}  (${item['created_by']['role']})",
                                purpose: item['purpose']);

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
                                    itemRow.createdBy,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.labourType,
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
                                    itemRow.block,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.dealerName,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.noofPeople,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.purpose,
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
        .collection(AppConstants.prod + "labourReport")
        .where("construction_site.constructionId",
            isEqualTo: widget.constructionId)
        .where("block.blockId", isEqualTo: widget.blockId)
        .where("dealer.dealerId", isEqualTo: widget.dealerId)
        .where("labour_type", isEqualTo: widget.labourType)
        .where("added_on", isGreaterThan: widget.startDate)
        .where("added_on", isLessThan: widget.endDate)
        .orderBy('added_on', descending: true)
        .getDocuments();
    int i = 0;
    List<List<String>> csvData = [
      // headers
      <String>[
        'S.No.',
        'Created On',
        'Created By',
        "Labour Type",
        "Construction Site",
        "Block",
        "Dealer Name",
        "No. of People",
        "Purpose"
      ],
      // data
      ...data.documents.map((result) {
        i++;
        return [
          i.toString(),
          DateTimeUtils.slashDateFormat(
              (result['added_on'] as Timestamp).toDate()),
          "${result['created_by']['name']}  (${result['created_by']['role']})",
          result['labour_type'],
          result['construction_site']['constructionSite'],
          result['block']['blockName'],
          result['dealer']['dealerName'],
          result['no_of_people'],
          result['purpose'],
        ];
      }),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/stockRegisterDocs.csv';

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
  String block;
  String labourType;
  String dealerName;
  String noofPeople;
  String purpose;
  String createdBy;

  ItemInfo({
    this.createdBy,
    this.slNo,
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
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Self employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      createdBy: "Vasanth (Manager)",
      purpose: "Plumbing"),
  ItemInfo(
      slNo: '2',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Out Sourcing employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      createdBy: "Vasanth (Manager)",
      purpose: "Plumbing"),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Self employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      createdBy: "Vasanth (Manager)",
      purpose: "Plumbing"),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      createdBy: "Vasanth (Manager)",
      block: "8th",
      labourType: "Out Sourcing employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"),
  ItemInfo(
      slNo: '4',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Self employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"),
];

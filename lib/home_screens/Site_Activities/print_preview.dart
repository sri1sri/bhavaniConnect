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

class PrintPreview extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String constructionId;
  final String constructionSite;
  final String categoryId;
  final String categoryName;
  final String blockId;
  final String blockName;
  final String subCategoryId;
  final String subCategoryName;

  const PrintPreview(
    this.startDate,
    this.endDate,
    this.constructionId,
    this.constructionSite,
    this.blockId,
    this.blockName,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
  );

  @override
  _PrintPreview createState() => _PrintPreview();
}

class _PrintPreview extends State<PrintPreview> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection(AppConstants.prod + "siteActivities")
        .where("construction_site.constructionId",
            isEqualTo: widget.constructionId)
        .where('category.categoryId', isEqualTo: widget.categoryId)
        .where("block.blockId", isEqualTo: widget.blockId)
        .where("sub_category.subCategoryId", isEqualTo: widget.subCategoryId)
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
                          widget.categoryName ?? "All",
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          " | ",
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          widget.subCategoryName ?? "All",
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
                        .collection(AppConstants.prod + "siteActivities")
                        .where("construction_site.constructionId",
                            isEqualTo: widget.constructionId)
                        .where('category.categoryId',
                            isEqualTo: widget.categoryId)
                        .where("block.blockId", isEqualTo: widget.blockId)
                        .where("sub_category.subCategoryId",
                            isEqualTo: widget.subCategoryId)
                        .where("added_on", isGreaterThan: widget.startDate)
                        .where("added_on", isLessThan: widget.endDate)
                        .orderBy('added_on', descending: true)
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
                              "Site",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Block",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Category",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Sub Category",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                              label: Text(
                                "UOM",
                                style: subTitleStyle1,
                              ),
                            ),
                            DataColumn(
                                label: Text(
                              "Total Progress",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Remarks",
                              style: subTitleStyle1,
                            )),
                          ],
                          rows: result.map((item) {
                            index++;
                            ItemInfo itemRow = ItemInfo(
                              slNo: index.toString(),
                              site: item['construction_site']
                                  ['constructionSite'],
                              date: DateTimeUtils.slashDateFormat(
                                  (item['added_on'] as Timestamp).toDate()),
                              createdBy:
                                  "${item['created_by']['name']}  (${item['created_by']['role']})",
                              category: item['category']['categoryName'],
                              subCategory: item['sub_category']
                                  ['subCategoryName'],
                              uom: item['unit']['unitName'],
                              block: item['block']['blockName'],
                              yesterdayProg: item['yesterday_progress'],
                              totalProg: item['total_progress'],
                              remarks: item['remark'],
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
                                    itemRow.createdBy,
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
                                    itemRow.category,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.subCategory,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.uom,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.totalProg,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.remarks,
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
        .collection(AppConstants.prod + "siteActivities")
        .where("construction_site.constructionId",
            isEqualTo: widget.constructionId)
        .where('category.categoryId', isEqualTo: widget.categoryId)
        .where("block.blockId", isEqualTo: widget.blockId)
        .where("sub_category.subCategoryId", isEqualTo: widget.subCategoryId)
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
        "Site",
        "Block",
        "Category",
        "Sub Category",
        "Uom",
        "Total Progress",
        "Remarks"
      ],
      // data
      ...data.documents.map((result) {
        i++;
        return [
          i.toString(),
          DateTimeUtils.slashDateFormat(
              (result['added_on'] as Timestamp).toDate()),
          "${result['created_by']['name']}  (${result['created_by']['role']})",
          result['construction_site']['constructionSite'],
          result['block']['blockName'],
          result['category']['categoryName'],
          result['sub_category']['subCategoryName'],
          result['unit']['unitName'],
          result['total_progress'],
          result['remark'],
        ];
      }),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/siteActivitiesDocs.csv';

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
  String createdBy;
  String date;
  String site;
  String block;
  String category;
  String uom;
  String subCategory;
  String yesterdayProg;
  String totalProg;
  String remarks;

  ItemInfo({
    this.slNo,
    this.createdBy,
    this.date,
    this.site,
    this.category,
    this.uom,
    this.block,
    this.subCategory,
    this.yesterdayProg,
    this.totalProg,
    this.remarks,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      block: "8th",
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '2',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      block: "8th",
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      createdBy: "Vasanth (Manager)",
      block: "8th",
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      block: "8th",
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '4',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      block: "8th",
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
];

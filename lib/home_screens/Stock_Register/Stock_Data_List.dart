import 'dart:io';

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/no_data_widget.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class StockDataList extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String constructionId;
  final String constructionSite;
  final String dealerId;
  final String categoryId;
  final String itemId;
  final String dealerName;
  final String categoryName;
  final String itemName;

  const StockDataList(
      this.startDate,
      this.endDate,
      this.constructionId,
      this.constructionSite,
      this.dealerId,
      this.categoryId,
      this.itemId,
      this.dealerName,
      this.categoryName,
      this.itemName);

  @override
  _StockDataList createState() => _StockDataList();
}

class _StockDataList extends State<StockDataList> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection(AppConstants.prod + "stockRegister")
        .where("category.categoryId", isEqualTo: widget.categoryId)
        .where("item.itemId", isEqualTo: widget.itemId)
        .where("dealer.dealerId", isEqualTo: widget.dealerId)
        .where("purchase_date", isGreaterThan: widget.startDate)
        .where("purchase_date", isLessThan: widget.endDate)
        .orderBy('purchase_date', descending: true)
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
          rightAction: () async {
            _generateCSVAndView(context);
          },
          primaryText: 'Stock Register',
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
                  height:getDynamicHeight(20),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: widget.constructionSite ?? "All",
                            ),
                            TextSpan(
                              text: " | ",
                            ),
                            TextSpan(
                              text: widget.dealerName ?? "All",
                            ),
                            TextSpan(
                              text: " | ",
                            ),
                            TextSpan(
                              text: widget.itemName ?? "All",
                            ),
                            TextSpan(
                              text: " | ",
                            ),
                            TextSpan(
                              text: widget.categoryName ?? "All",
                            ),
                          ],
                          style: descriptionStyleDarkBlur2,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: getDynamicHeight(20),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection(AppConstants.prod + "stockRegister")
                        .where('construction_site.constructionId',
                            isEqualTo: widget.constructionId)
                        .where("category.categoryId",
                            isEqualTo: widget.categoryId)
                        .where("item.itemId", isEqualTo: widget.itemId)
                        .where("dealer.dealerId", isEqualTo: widget.dealerId)
                        .where("purchase_date", isGreaterThan: widget.startDate)
                        .where("purchase_date", isLessThan: widget.endDate)
                        .orderBy('purchase_date', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error),
                        );
                      } else {
                        List<DocumentSnapshot> result = snapshot.data.documents;
                        if (result.length == 0) {
                          return NoDataWidget();
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
                              "Purchased Date",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Site",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Item Description",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Category",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Uom",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                              label: Text(
                                "Dealer Name",
                                style: subTitleStyle1,
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Invoice No.",
                                style: subTitleStyle1,
                              ),
                            ),
                            DataColumn(
                                label: Text(
                              "Received Quantity",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Issued Quantity",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Balance Quantity",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Rate",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Sub Total",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "GST Amount",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Total Amount",
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
                                createdOn: DateTimeUtils.slashDateFormat(
                                    (item['added_on'] as Timestamp).toDate()),
                                createdBy:
                                    "${item['created_by']['name']}  (${item['created_by']['role']})",
                                date: DateTimeUtils.slashDateFormat(
                                    (item['purchase_date'] as Timestamp)
                                        .toDate()),
                                site: item['construction_site']
                                    ['constructionSite'],
                                itemDescription: item['item']['itemName'],
                                category: item['category']['categoryName'],
                                umo: item['unit']['unitName'],
                                supplierName: item['dealer']['dealerName'],
                                invoiceNo: item['invoice_no'],
                                receivedQty: item['received_quantity'],
                                issuedQty: item['issued_quantity'],
                                balanceQty: item['balance_quantity'],
                                rate: "₹${item['rate']}",
                                subTotal: "₹${item['sub_total']}",
                                gstAmount: "₹${item['gst_amount']}",
                                totalAmt: "₹${item['total_amount_gst']}",
                                remarks: item['remarks']);

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
                                    itemRow.createdOn,
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
                                    itemRow.date,
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
                                    itemRow.itemDescription,
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
                                    itemRow.umo,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.supplierName,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.invoiceNo,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.receivedQty,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.issuedQty,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.balanceQty,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.rate,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.subTotal,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.gstAmount,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.totalAmt,
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
        .collection(AppConstants.prod + "stockRegister")
        .where("category.categoryId", isEqualTo: widget.categoryId)
        .where("item.itemId", isEqualTo: widget.itemId)
        .where("dealer.dealerId", isEqualTo: widget.dealerId)
        .where("purchase_date", isGreaterThan: widget.startDate)
        .where("purchase_date", isLessThan: widget.endDate)
        .orderBy('purchase_date', descending: true)
        .getDocuments();
    int i = 0;
    List<List<String>> csvData = [
      // headers
      <String>[
        'S.No.',
        'Created On',
        'Created By',
        "Purchased Date",
        "Site",
        "Item Description",
        "Category",
        "Uom",
        "Dealer Name",
        "Invoice No.",
        "Received Quantity",
        "Issued Quantity",
        "Balance Quantity",
        "Rate",
        "Sub Total",
        "GST Amount",
        "Total Amount",
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
          DateTimeUtils.slashDateFormat(
              (result['purchase_date'] as Timestamp).toDate()),
          result['construction_site']['constructionSite'],
          result['item']['itemName'],
          result['category']['categoryName'],
          result['unit']['unitName'],
          result['dealer']['dealerName'],
          result['invoice_no'],
          result['received_quantity'],
          result['issued_quantity'],
          result['balance_quantity'],
          "₹${result['rate']}",
          "₹${result['sub_total']}",
          "₹${result['gst_amount']}",
          "₹${result['total_amount_gst']}",
          result['remarks']
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
  String createdOn;
  String createdBy;
  String date;
  String site;
  String itemDescription;
  String category;
  String umo;
  String supplierName;
  String invoiceNo;
  String receivedQty;
  String issuedQty;
  String balanceQty;
  String rate;
  String subTotal;
  String gstAmount;
  String totalAmt;
  String remarks;

  ItemInfo({
    this.slNo,
    this.createdOn,
    this.createdBy,
    this.date,
    this.site,
    this.itemDescription,
    this.category,
    this.umo,
    this.supplierName,
    this.invoiceNo,
    this.receivedQty,
    this.issuedQty,
    this.balanceQty,
    this.rate,
    this.subTotal,
    this.gstAmount,
    this.totalAmt,
    this.remarks,
  });
}

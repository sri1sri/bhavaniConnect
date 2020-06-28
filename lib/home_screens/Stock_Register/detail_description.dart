import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/no_data_widget.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddIssueDetails.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class DetailDescription extends StatefulWidget {
  final String documentId;
  final String constructionId;
  final String currentUserId;

  const DetailDescription(
      {Key key, this.documentId, this.constructionId, this.currentUserId})
      : super(key: key);

  @override
  _DetailDescription createState() => _DetailDescription();
}

class _DetailDescription extends State<DetailDescription> {
  int index = 0;
  int issuedQuantity = 0;

  @override
  void initState() {
    super.initState();
    getIssuedQuantity();
  }

  getIssuedQuantity() {
    Firestore.instance
        .collection(AppConstants.prod + 'stockIssued')
        .where('stockId', isEqualTo: widget.documentId)
        .orderBy('added_on', descending: false)
        .getDocuments()
        .then((value) {
      List<DocumentSnapshot> issuedResult = value.documents;

      for (int i = 0; i < issuedResult.length; i++) {
        setState(() {
          issuedQuantity += int.parse(issuedResult[i]['issuedQuantity']);
        });
      }
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
            primaryText: 'Stock Details',
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
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection(AppConstants.prod + "stockRegister")
                            .document(widget.documentId)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            var result = snapshot.data;
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  subtext(
                                      "Created On",
                                      DateTimeUtils.slashDateFormat(
                                          (result['added_on'] as Timestamp)
                                              .toDate())),
                                  subtext("Created By",
                                      "${result['created_by']['name']}  (${result['created_by']['role']})"),
                                  subtext(
                                      "Purchased Date",
                                      DateTimeUtils.slashDateFormat(
                                          (result['purchase_date'] as Timestamp)
                                              .toDate())),
                                  subtext(
                                      "Site",
                                      result['construction_site']
                                          ['constructionSite']),
                                  subtext(
                                    "Item\nDescription",
                                    result['item']['itemName'],
                                  ),
                                  subtext("Category",
                                      result['category']['categoryName']),
                                  subtext("Uom", result['unit']['unitName']),
                                  subtext("Supplier name",
                                      result['dealer']['dealerName']),
                                  subtext("Invoice No.", result['invoice_no']),
                                  subtext("Received Quantity",
                                      result['received_quantity']),
                                  subtext(
                                      "Issued Quantity",
                                      issuedQuantity == 0
                                          ? result['issued_quantity']
                                          : issuedQuantity.toString()),
                                  subtext("Balance Quantity",
                                      result['balance_quantity']),
                                  subtext("Rate", "₹${result['rate']}"),
                                  subtext(
                                      "Sub Total", "₹${result['sub_total']}"),
                                  subtext(
                                      "GST Amount", "₹${result['gst_amount']}"),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black54,
                                  ),
                                  totalsubtext("Total Amount",
                                      "₹${result['total_amount_gst']}"),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Remarks:",
                                        style: subTitleStyle,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        result['remarks'],
                                        style: descriptionStyleDarkBlur1,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Issue Details:",
                                    style: subTitleStyle,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black54,
                                  ),
                                  Container(
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection(AppConstants.prod +
                                                    'stockIssued')
                                                .where('stockId',
                                                    isEqualTo:
                                                        widget.documentId)
                                                .orderBy('added_on',
                                                    descending: false)
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              index = 0;
                                              issuedQuantity = 0;
                                              if (!snapshot.hasData) {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(snapshot.error),
                                                );
                                              } else {
                                                List<DocumentSnapshot> result =
                                                    snapshot.data.documents;
                                                if (result.length == 0) {
                                                  return NoDataWidget();
                                                }
                                                return DataTable(
                                                  onSelectAll: (b) {},
                                                  sortAscending: true,
                                                  columns: <DataColumn>[
                                                    DataColumn(
                                                        label: Text(
                                                      'Sl.No',
                                                      style: subTitleStyle,
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'Date',
                                                      style: subTitleStyle,
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'Issued Quantity',
                                                      style: subTitleStyle,
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'Issued By',
                                                      style: subTitleStyle,
                                                    )),
                                                    DataColumn(
                                                        label: Text(
                                                      'Issued To',
                                                      style: subTitleStyle,
                                                    )),
                                                  ],
                                                  rows: result.map((item) {
                                                    index++;
                                                    issuedQuantity += int.parse(
                                                        item['issuedQuantity']);
                                                    ItemInfo itemRow = ItemInfo(
                                                        slNo: index.toString(),
                                                        date: item['added_on'] !=
                                                                null
                                                            ? DateTimeUtils.slashDateFormat(
                                                                (item['added_on']
                                                                        as Timestamp)
                                                                    .toDate())
                                                            : '',
                                                        issuedBy: item[
                                                                    'created_by'] !=
                                                                null
                                                            ? "${item['created_by']['name']}  (${item['created_by']['role']})"
                                                            : '',
                                                        issuedTo: item[
                                                                    'issued_to'] !=
                                                                null
                                                            ? "${item['issued_to']['name']}  (${item['issued_to']['role']})"
                                                            : '',
                                                        issuedQuantity: item[
                                                            'issuedQuantity']);

                                                    return DataRow(
                                                      cells: [
                                                        DataCell(Text(
                                                          itemRow.slNo,
                                                          style:
                                                              descriptionStyleDark,
                                                        )),
                                                        DataCell(Text(
                                                          itemRow.date,
                                                          style:
                                                              descriptionStyleDark,
                                                        )),
                                                        DataCell(Text(
                                                          itemRow
                                                              .issuedQuantity,
                                                          style:
                                                              descriptionStyleDark,
                                                        )),
                                                        DataCell(Text(
                                                          itemRow.issuedBy,
                                                          style:
                                                              descriptionStyleDark,
                                                        )),
                                                        DataCell(Text(
                                                          itemRow.issuedTo,
                                                          style:
                                                              descriptionStyleDark,
                                                        )),
                                                      ],
                                                    );
                                                  }).toList(),
                                                );
                                              }
                                            })),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(
                      height: getDynamicHeight(150),
                    ),
                  ]))),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  GoToPage(
                      context,
                      IssuedDetails(
                        constructionId: widget.constructionId,
                        stockId: widget.documentId,
                        currentUserId: widget.currentUserId,
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
        ));
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
  String issuedQuantity;
  String issuedBy;
  String issuedTo;

  ItemInfo({
    this.slNo,
    this.date,
    this.issuedQuantity,
    this.issuedBy,
    this.issuedTo,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: "1",
      date: "29/10/2010",
      issuedBy: "Vasanth(Manager)",
      issuedTo: "Srivatsav(Site Engineer)",
      issuedQuantity: "2343"),
  ItemInfo(
      slNo: "2",
      date: "29/10/2010",
      issuedBy: "Vasanth(Manager)",
      issuedTo: "Srivatsav(Site Engineer)",
      issuedQuantity: "2343"),
  ItemInfo(
      slNo: "3",
      date: "29/10/2010",
      issuedBy: "Vasanth(Manager)",
      issuedTo: "Srivatsav(Site Engineer)",
      issuedQuantity: "2343"),
];

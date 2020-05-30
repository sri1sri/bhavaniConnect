import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StockDataList extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String dealerId;
  final String categoryId;
  final String itemId;
  final String dealerName;
  final String categoryName;
  final String itemName;

  const StockDataList(
      this.startDate,
      this.endDate,
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

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection("stockRegister")
        .where("category.categoryId", isEqualTo: widget.categoryId)
        .where("item.itemId", isEqualTo: widget.itemId)
        .where("dealer.dealerId", isEqualTo: widget.dealerId)
        .where("added_on", isGreaterThan: widget.startDate)
        .where("added_on", isLessThan: widget.endDate)
        .orderBy('added_on', descending: true)
        .getDocuments();
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
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
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Stock Register',
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
                  height: 20,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.dealerName,
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          " | ",
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          widget.itemName,
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          " | ",
                          style: descriptionStyleDarkBlur2,
                        ),
                        Text(
                          widget.categoryName,
                          style: descriptionStyleDarkBlur2,
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("stockRegister")
                        .where("category.categoryId",
                            isEqualTo: widget.categoryId)
                        .where("item.itemId", isEqualTo: widget.itemId)
                        .where("dealer.dealerId", isEqualTo: widget.dealerId)
                        .where("added_on", isGreaterThan: widget.startDate)
                        .where("added_on", isLessThan: widget.endDate)
                        .orderBy('added_on', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        List<DocumentSnapshot> result = snapshot.data.documents;

                        return DataTable(
                          onSelectAll: (b) {},
                          sortAscending: true,
                          showCheckboxColumn: false,
                          dataRowHeight: 70.0,
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
                                createdBy: "Vasanth (Manager)",
                                date: '29/Oct/2020',
                                site: item['construction_site']
                                    ['constructionSite'],
                                itemDescription: item['item']['ItemName'],
                                category: item['category']['categoryName'],
                                umo: item['unit']['unitName'],
                                supplierName: 'Vasanth Steels',
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
                  height: 500,
                )
              ],
            ),
          ),
        ),
      ),
    );
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

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      createdOn: '03/Nov/2020',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      umo: 'Tons',
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate: '₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '2',
      createdOn: '03/Nov/2020',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      umo: 'Tons',
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate: '₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '3',
      createdOn: '03/Nov/2020',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      createdBy: "Vasanth (Manager)",
      umo: 'Tons',
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate: '₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '4',
      createdOn: '03/Nov/2020',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      umo: 'Tons',
      createdBy: "Vasanth (Manager)",
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate: '₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '5',
      createdOn: '03/Nov/2020',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      umo: 'Tons',
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      createdBy: "Vasanth (Manager)",
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate: '₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'),
];

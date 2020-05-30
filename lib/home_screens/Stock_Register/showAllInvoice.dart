import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/AddNewInvoice.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/Stock_Filter.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/detail_description.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowAllInvoice extends StatefulWidget {
  final String currentUserId;

  const ShowAllInvoice({Key key, this.currentUserId}) : super(key: key);

  @override
  _ShowAllInvoice createState() => _ShowAllInvoice();
}

class _ShowAllInvoice extends State<ShowAllInvoice> {
  DateTime startFilterDate = DateTimeUtils.currentDayDateTimeNow;
  DateTime endFilterDate =
      DateTimeUtils.currentDayDateTimeNow.add(Duration(days: 1));

  String constructionSiteId;
  String categoryId;
  String itemId;
  String dealerId;

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

  int _n = 0;
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
    var size = MediaQuery.of(context).size;
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
          rightActionBar: userRole != null &&
                  (userRole == UserRoles.Admin ||
                      userRole == UserRoles.StoreManager ||
                      userRole == UserRoles.Accountant ||
                      userRole == UserRoles.Manager)
              ? Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.white,
                )
              : Container(height: 0, width: 0),
          rightAction: () {
            GoToPage(
                context,
                StockFilter(
                  startDate: startFilterDate,
                  endDate: endFilterDate,
                  categoryId: categoryId,
                  dealerId: dealerId,
                  itemId: itemId,
                  constructionId: constructionSiteId,
                  returnFunction: (startDate, endDate, constructionId, dealerId,
                      categoryId, itemId) {
                    setState(() {
                      startFilterDate = startDate;
                      endFilterDate = endDate;
                      constructionSiteId = constructionSiteId;
                      dealerId = dealerId;
                      categoryId = categoryId;
                      itemId = itemId;
                    });
                  },
                ));
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
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection("stockRegister")
                  .where("construction_site.constructionId",
                      isEqualTo: constructionSiteId)
                  .where("category.categoryId", isEqualTo: categoryId)
                  .where("item.itemId", isEqualTo: itemId)
                  .where("dealer.dealerId", isEqualTo: dealerId)
                  .where("added_on", isGreaterThan: startFilterDate)
                  .where("added_on", isLessThan: endFilterDate)
                  .orderBy('added_on', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var result = snapshot.data.documents;
                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return StockRegister(
                          size,
                          context,
                          result[index].documentID,
                          DateTimeUtils.formatDayMonthYear(
                              (result[index]['added_on'] as Timestamp)
                                  .toDate()),
                          result[index]['construction_site']
                              ['constructionSite'],
                          "28 Tons of TMT rods with steel blend.",
                          result[index]['category']['categoryName'],
                          result[index]['invoice_no'],
                          double.parse(result[index]['total_amount_gst'])
                              .toStringAsFixed(2));
                    },
                  );
                }
              }),
        ),
      ),
      floatingActionButton: userRole != null &&
              (userRole == UserRoles.Admin ||
                  userRole == UserRoles.StoreManager ||
                  userRole == UserRoles.Manager)
          ? FloatingActionButton(
              onPressed: () {
                GoToPage(
                    context,
                    AddInvoice(
                      currentUserId: widget.currentUserId,
                    ));
              },
              child: Icon(Icons.add),
              backgroundColor: backgroundColor,
            )
          : null,
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
    this.date,
    this.createdOn,
    this.createdBy,
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
      createdBy: "Vasanth(Manager)",
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
      createdBy: "Vasanth(Manager)",
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
      slNo: '3',
      createdOn: '03/Nov/2020',
      createdBy: "Vasanth(Manager)",
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
      slNo: '4',
      createdOn: '03/Nov/2020',
      createdBy: "Vasanth(Manager)",
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
      slNo: '5',
      createdOn: '03/Nov/2020',
      createdBy: "Vasanth(Manager)",
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
];

Widget StockRegister(
    Size size,
    BuildContext context,
    String documentId,
    String date,
    String site,
    String description,
    String category,
    String invoiceNo,
    String total) {
  return GestureDetector(
    onTap: () {
      GoToPage(
          context,
          DetailDescription(
            documentId: documentId,
          ));
    },
    child: Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20),
      child: Container(
        width: double.infinity,
        height: 210,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 15,
              top: 0,
              child: Text(date, style: descriptionStyleDarkBlur3),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 24,
                  top: 24,
                  right: size.width * .35,
                ),
                height: 185,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA).withOpacity(.45),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(site, style: subTitleStyle1),
                    SizedBox(height: 10),
                    Expanded(
                      child: Text(description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleStyleDark1),
                    ),
                    Text(category, style: subTitleStyle),
                    SizedBox(height: 10),
                    Text(
                      "Invoice No.:$invoiceNo",
                      style: descriptionStyleDarkBlur1,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: 50,
                width: size.width * .35,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Text("₹ $total", style: subTitleStyleLight),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddNewInvoice.dart';

class DetailDescription extends StatefulWidget {
  final String documentId;

  const DetailDescription({Key key, this.documentId}) : super(key: key);

  @override
  _DetailDescription createState() => _DetailDescription();
}

class _DetailDescription extends State<DetailDescription> {
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
            // rightActionBar: Icon(
            //   Icons.border_color,
            //   size: 25,
            //   color: Colors.white,
            // ),
            rightAction: () {
              GoToPage(context, AddInvoice());
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
                      height: 20,
                    ),
                    StreamBuilder(
                        stream: Firestore.instance
                            .collection("stockRegister")
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
                                  subtext("Created By", "Vasanth (Manager)"),
                                  subtext("Purchased Date", "29/Oct/2020"),
                                  subtext(
                                      "Site",
                                      result['construction_site']
                                          ['constructionSite']),
                                  subtext(
                                    "Item\nDescription",
                                    result['item']['ItemName'],
                                  ),
                                  subtext("Category",
                                      result['category']['categoryName']),
                                  subtext("Uom", result['unit']['unitName']),
                                  subtext("Supplier name", "Vasanth Steels"),
                                  subtext("Invoice No.", result['invoice_no']),
                                  subtext("Received Quantity",
                                      result['received_quantity']),
                                  subtext("Issued Quantity",
                                      result['issued_quantity']),
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
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
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
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                    SizedBox(
                      height: 150,
                    ),
                  ]))),
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

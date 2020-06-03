import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Add_Goods.dart';

class GoodsScreen extends StatefulWidget {
  final String currentUserId;

  const GoodsScreen({Key key, this.currentUserId}) : super(key: key);

  @override
  _GoodsScreen createState() => _GoodsScreen();
}

class _GoodsScreen extends State<GoodsScreen> {
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
          primaryText: 'Goods Details',
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
                  height: 10,
                ),
                goodsDetails(
                    size,
                    context,
                    "29 Oct 2020",
                    "12.30 am",
                    "Bhavani Vivan",
                    "Vasanth Agencies",
                    "Iron/Steel",
                    "Vasanthakumar (Security)",
                    "Srivatsav (Manager)",
                    "Approved"),
                goodsDetails(
                    size,
                    context,
                    "02 Nov 2020",
                    "04.20 pm",
                    "Bhavani Aravindam",
                    "Sri Agencies",
                    "Sand",
                    "Vamsi (Security)",
                    "Vatsav (Manager)",
                    "Pending"),
                goodsDetails(
                    size,
                    context,
                    "14 Nov 2020",
                    "02.54 am",
                    "Bhavani Vivan",
                    "Vamsi Agencies",
                    "Plastics",
                    "Vimal (Security)",
                    "Rockstar (Manager)",
                    "Declined"),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoToPage(context, AddGoods());
        },
        child: Icon(Icons.add),
        backgroundColor: backgroundColor,
      ),
    );
  }
}

Widget goodsDetails(
    Size size,
    BuildContext context,
    String date,
    String time,
    String site,
    String dealer,
    String category,
    String requestedBy,
    String approvedBy,
    String approvalStatus) {
  return Padding(
    padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20),
    child: Container(
      width: double.infinity,
      height: 240,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 15,
            top: 0,
            child: Text("$date - $time", style: descriptionStyleDarkBlur3),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 14,
                top: 20,
                //right: size.width * .35,
              ),
              height: 215,
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
                  Text(
                    "Dealer: $dealer",
                    style: descriptionStyleDarkBlur1,
                  ),
                  SizedBox(height: 10),
                  Text(category, style: subTitleStyle),
                  SizedBox(height: 10),
                  Expanded(
                    child: Text("Requested By:\n$requestedBy",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: descriptionStyleDark1),
                  ),
                  Expanded(
                    child: Text("Approved By: \n$approvedBy",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: descriptionStyleDark1),
                  ),
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
                  color: approvalStatus == 'Approved'
                      ? Colors.green.withOpacity(0.8)
                      : (approvalStatus == 'Pending'
                          ? Colors.orange.withOpacity(0.8)
                          : Colors.red.withOpacity(0.8)),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Text(approvalStatus, style: subTitleStyleLight),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

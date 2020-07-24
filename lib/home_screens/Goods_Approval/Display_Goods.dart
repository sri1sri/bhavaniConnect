import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/no_data_widget.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

import 'Add_Goods.dart';
import 'Search_Goods.dart';

class GoodsScreen extends StatefulWidget {
  final String currentUserId;

  const GoodsScreen({Key key, this.currentUserId}) : super(key: key);

  @override
  _GoodsScreen createState() => _GoodsScreen();
}

class _GoodsScreen extends State<GoodsScreen> {
  DateTime startFilterDate = DateTimeUtils.currentDayDateTimeNow;
  DateTime endFilterDate =
      DateTimeUtils.currentDayDateTimeNow.add(Duration(days: 1));
  UserRoles userRole;
  String userRoleValue;
  String userName;

  DateTime selectedDateFrom = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");
  Future<Null> showPickerFrom(BuildContext context) async {
    final DateTime pickedFrom = await showDatePicker(
      context: context,
      initialDate: selectedDateFrom,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (pickedFrom != null) {
      setState(() {
        print(customFormat.format(pickedFrom));
        selectedDateFrom = pickedFrom;
        startFilterDate =
            DateTime(pickedFrom.year, pickedFrom.month, pickedFrom.day);
        endFilterDate =
            DateTime(pickedFrom.year, pickedFrom.month, pickedFrom.day + 1);
        print(startFilterDate);
        print('startFilterDate--------');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserParams();
  }

  getUserParams() async {
    var prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("userRole");
    String name = prefs.getString("userName");
    setState(() {
      userRole = userRoleValues[role];
      userRoleValue = role;
      userName = name;
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(72),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: getDynamicHeight(15),
                ),
                Container(
                  height: getDynamicHeight(80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: getDynamicHeight(45),
                          left: getDynamicWidth(20),
                        ),
                        child: InkWell(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, getDynamicHeight(30), 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Goods Details",
                              textAlign: TextAlign.center,
                              style: appBarTitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            top: getDynamicHeight(35),
                            right: getDynamicWidth(10),
                          ),
                          child: Row(
                            children: [
                              (userRole == UserRoles.Manager ||
                                  userRole == UserRoles.StoreManager ||
                                  userRole == UserRoles.Securtiy ||
                                  userRole == UserRoles.Supervisor ||
                                  userRole == UserRoles.Admin)
                                  ? GestureDetector(
                                    child: Icon(
                                Icons.calendar_today,
                                size: 25,
                                color: Colors.white,
                              ),
                                onTap: ()
                                {
                                  showPickerFrom(context);
                                },
                                  ): null,
                              SizedBox(width: 5,),
                              IconButton(
                                icon: Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GoodsFilter(),
                                    ),
                                  );
                                },
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
//      appBar: PreferredSize(
//        preferredSize: Size.fromHeight(72),
//        child: CustomAppBarDark(
//          leftActionBar: Icon(
//            Icons.arrow_back_ios,
//            size: 25,
//            color: Colors.white,
//          ),
//          leftAction: () {
//            Navigator.pop(context, true);
//          },
//          rightActionBar: (userRole == UserRoles.Manager ||
//                  userRole == UserRoles.StoreManager ||
//                  userRole == UserRoles.Securtiy ||
//                  userRole == UserRoles.Supervisor ||
//                  userRole == UserRoles.Admin)
//              ? Icon(
//                  Icons.calendar_today,
//                  size: 25,
//                  color: Colors.white,
//                )
//              : null,
//          rightAction: (userRole == UserRoles.Manager ||
//                  userRole == UserRoles.StoreManager ||
//                  userRole == UserRoles.Securtiy ||
//                  userRole == UserRoles.Supervisor ||
//                  userRole == UserRoles.Admin)
//              ? () {
//                  showPickerFrom(context);
//                  // GoToPage(context, VehicleFilter());
//                }
//              : null,
//          primaryText: 'Goods Details',
//          tabBarWidget: null,
//        ),
//      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          height: double.infinity,
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection(AppConstants.prod + "goodsApproval")
                  .where("added_on", isGreaterThan: startFilterDate)
                  .where("added_on", isLessThan: endFilterDate)
                  .orderBy('added_on', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var result = snapshot.data.documents;
                  if (result.length == 0) {
                    return NoDataWidget();
                  }
                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return goodsDetails(
                        size,
                        context,
                        DateTimeUtils.dayMonthYearTimeFormat(
                            (result[index]['added_on'] as Timestamp).toDate()),
                        result[index]['construction_site']['constructionSite'],
                        result[index]['dealer']['dealerName'],
                        result[index]['concrete_type']['concreteTypeName'],
                        result[index]['created_by']['name'] ?? "-",
                        result[index]['approved_by']['name'] ?? "-",
                        result[index]['status'] != null
                            ? result[index]['status']
                            : "Pending",
                        topPadding: index == 0 ? 40.0 : 20.0,
                      );
                    },
                  );
                }
              }),
        ),
      ),
      floatingActionButton: (userRole == UserRoles.Manager ||
              userRole == UserRoles.Securtiy ||
              userRole == UserRoles.Admin)
          ? FloatingActionButton(
              onPressed: () {
                GoToPage(
                    context,
                    AddGoods(
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

Widget goodsDetails(
    Size size,
    BuildContext context,
    String date,
    // String time,
    String site,
    String dealer,
    String category,
    String requestedBy,
    String approvedBy,
    String approvalStatus,
    {double topPadding = 20.0}) {
  return Padding(
    padding: EdgeInsets.only(right: 15.0, left: 15, top: topPadding),
    child: Container(
      width: double.infinity,
      height: getDynamicHeight(280),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 15,
            top: 0,
            child: Text("$date", style: descriptionStyleDarkBlur3),
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
              height: getDynamicHeight(255),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA).withOpacity(.45),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(site, style: subTitleStyle1),
                  SizedBox(height: getDynamicHeight(10),),
                  Text(
                    "Dealer: $dealer",
                    style: descriptionStyleDarkBlur1,
                  ),
                  SizedBox(height: getDynamicHeight(10)),
                  Text(category, style: subTitleStyle),
                  SizedBox(height: getDynamicHeight(10)),
                  Text(
                    "Vehicle Number: TN66V6571",
                    style: descriptionStyleDarkBlur1,
                  ),
                  SizedBox(height: getDynamicHeight(10)),
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
              height: getDynamicHeight(60),
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

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/no_data_widget.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  final String currentUserId;

  const NotificationPage({Key key, this.currentUserId}) : super(key: key);
  @override
  _F_NotificationPageState createState() => _F_NotificationPageState();
}

class _F_NotificationPageState extends State<NotificationPage> {
  // DateTime endFilterDate = DateTimeUtils.currentDayDateTimeNow;
  // DateTime startFilterDate =
  //     DateTimeUtils.currentDayDateTimeNow.add(Duration(days: -1));
  DateTime startFilterDate = DateTimeUtils.currentDayDateTimeNow;
  DateTime endFilterDate =
      DateTimeUtils.currentDayDateTimeNow.add(Duration(days: 1));

  UserRoles userRole;
  String userRoleValue;
  String userName;

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection("pendingRequests")
        .where("created_by.id", isEqualTo: widget.currentUserId)
        .where("added_on", isGreaterThan: startFilterDate)
        .where("added_on", isLessThan: endFilterDate)
        .orderBy('added_on', descending: true)
        .getDocuments();
    Firestore.instance
        .collection("pendingRequests")
        .where("permissions", arrayContains: widget.currentUserId)
        .where("added_on", isGreaterThan: startFilterDate)
        .where("added_on", isLessThan: endFilterDate)
        .orderBy('added_on', descending: true)
        .getDocuments();

    getUserParams();
  }

  getUserParams() async {
    var prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("userRole");
    String name = prefs.getString("userName");
    // userConstructionSiteId = prefs.getString("userConstSiteId");
    // userConstructionSite = prefs.getString("userConstSite");
    setState(() {
      userRole = userRoleValues[role];
      userRoleValue = role;
      userName = name;
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
          //rightActionBar: Icon(Icons.clear,size: 25,color: Colors.white),
          rightAction: () {
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Notifications',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0), topLeft: Radius.circular(40.0)),
        child: Container(
          color: Colors.white,
          height: double.infinity,
          // child: ListView(
          //   children: <Widget>[
          //     NotificationCard(
          //         size,
          //         context,
          //         "Approved",
          //         "29/Oct/2020",
          //         "10.30am",
          //         "Bhavani Vivan",
          //         "images/s3.png",
          //         "Vehicle Entry",
          //         "TN66V6571 - Goods Truck",
          //         "Sand load 2 tons for 2nd block"),
          //     NotificationCard(
          //         size,
          //         context,
          //         "Pending",
          //         "30/Oct/2020",
          //         "12.22pm",
          //         "Bhavani Aravindam",
          //         "images/s3.png",
          //         "Goods Approval",
          //         "Iron/Steel - Goods",
          //         "8 Layers SuperStrong Tmt rods"),
          //     NotificationCard(
          //         size,
          //         context,
          //         "Declined",
          //         "31/Oct/2020",
          //         "04.42pm",
          //         "Bhavani Vivan",
          //         "images/s3.png",
          //         "Vehicle Entry",
          //         "AP66Y7263 - Road Roller",
          //         "2 units of trip counts"),
          //   ],
          // ),
          child: StreamBuilder(
              stream: userRole == UserRoles.Securtiy
                  ? Firestore.instance
                      .collection("pendingRequests")
                      .where("created_by.id", isEqualTo: widget.currentUserId)
                      .where("added_on", isGreaterThan: startFilterDate)
                      .where("added_on", isLessThan: endFilterDate)
                      .orderBy('added_on', descending: true)
                      .snapshots()
                  : Firestore.instance
                      .collection("pendingRequests")
                      .where("permissions", arrayContains: widget.currentUserId)
                      .where("added_on", isGreaterThan: startFilterDate)
                      .where("added_on", isLessThan: endFilterDate)
                      .orderBy('added_on', descending: true)
                      .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var result = snapshot.data.documents;
                  if (snapshot.data.documents.length == 0) {
                    return NoDataWidget();
                  }
                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      if (result[index]['collectionName'] != null) {
                        print(result[index]['collectionName']);
                        return StreamBuilder(
                            stream: Firestore.instance
                                .collection(result[index]['collectionName'])
                                .document(result[index]['collectionDocId'])
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot>
                                    snapshotSecond) {
                              if (!snapshotSecond.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                var resultData = snapshotSecond.data.data;
                                // print(resultData[index]['construction_site']
                                //     ['constructionId']);
                                var res = resultData;
                                print(index);

                                if (res == null) {
                                  return Container();
                                }

                                return notificationCard(
                                  size,
                                  context,
                                  res['status'],
                                  DateTimeUtils.slashDateFormat(
                                      (res['added_on'] as Timestamp).toDate()),
                                  DateTimeUtils.hourMinuteFormat(
                                      (res['added_on'] as Timestamp).toDate()),
                                  res['construction_site']['constructionSite'],
                                  "images/s3.png",
                                  result[index]['collectionName'] ==
                                          "vehicleEntries"
                                      ? "Vehicle Entry"
                                      : "Goods Approval",
                                  result[index]['collectionName'] ==
                                              "vehicleEntries" &&
                                          res['units'] != null
                                      ? "${res['vehicleNumber']} (${res['unitsPerTrip'] ?? ''} ${res['units']['unitName'] ?? ''}) - Goods Truck"
                                      : res['concrete_type'] != null &&
                                              res['concrete_type']
                                                      ['concreteTypeName'] !=
                                                  null
                                          ? "${res['concrete_type']['concreteTypeName']} - Goods"
                                          : "Goods",
                                  res['dealer'] != null
                                      ? res['dealer']['dealerName'] ?? ''
                                      : '',
                                  res['created_by']['name'] != null &&
                                          res['created_by']['role'] != null
                                      ? " ${res['created_by']['name']} (${res['created_by']['role']})"
                                      : "-",
                                  res['approved_by']['name'] != null &&
                                          res['approved_by']['name']
                                              .isNotEmpty &&
                                          res['approved_by']['role'] != null
                                      ? " ${res['approved_by']['name']} (${res['approved_by']['role']})"
                                      : "-",
                                  result[index]['collectionName'],
                                  result[index]['collectionDocId'],
                                  topPadding: index == 0 ? 40.0 : 20.0,
                                );
                                // return result[index]['collectionName'] ==
                                //         "vehicleEntries"
                                //     ? Text(
                                //         resultData[index]['vehicleNumber'])
                                //     : Text(resultData[index]
                                //             ['concrete_type']
                                //         ['concreteTypeName']);
                              }
                            });
                      }
                      return Container();

                      // return VehicleDetails(
                      //   size,
                      //   context,
                      //   DateTimeUtils.dayMonthYearTimeFormat(
                      //       (result[index]['added_on'] as Timestamp)
                      //           .toDate()),
                      //   // "12.30 am",
                      //   result[index]['construction_site']
                      //       ['constructionSite'],
                      //   result[index]['dealer']['dealerName'],
                      //   result[index]['vehicleNumber'],
                      //   "${result[index]['created_by']['name']} (${result[index]['created_by']['role']})",
                      //   "${result[index]['created_by']['name']} (${result[index]['created_by']['role']})",
                      //   result[index]['status'] != null
                      //       ? result[index]['status']
                      //       : "Pending",

                      //   AddVehicleDetails(
                      //     currentUserId: widget.currentUserId,
                      //     documentId: result[index]['documentId'],
                      //   ),
                      //   //AddVehicleDetails
                      //   //AddVehicleCountDetails
                      // );
                    },
                  );
                }
              }),
        ),
      ),
    );
  }

  Widget notificationCard(
      Size size,
      BuildContext context,
      String approvalStatus,
      String date,
      String time,
      String site,
      String imgPath,
      String title,
      String content,
      String description,
      String requestedBy,
      String approvedBy,
      String collectionName,
      String documentId,
      {double topPadding = 20.0}) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(right: 15.0, left: 15, top: topPadding),
        child: Container(
          width: double.infinity,
          height: 225,
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: 35,
                  top: 0,
                  child: Container(
                    height: 8,
                    width: 40,
                    decoration: BoxDecoration(
                        color: approvalStatus == 'Approved'
                            ? Colors.green.withOpacity(0.8)
                            : (approvalStatus == 'Pending'
                                ? Colors.orange.withOpacity(0.8)
                                : Colors.red.withOpacity(0.8)),
                        borderRadius: BorderRadius.circular(3)),
                  )),
//            Positioned(
//              right:15,
//              top: 0,
//              child:Text(
//                  date,
//                  style: descriptionStyleDarkBlur3
//              ),
//            ),

              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 15,
                    //right: size.width * .35,
                  ),
                  height: 215,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        new BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6.0,
                            spreadRadius: 7),
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            approvalStatus,
                            style: TextStyle(
                                color: approvalStatus == 'Approved'
                                    ? Colors.green.withOpacity(0.8)
                                    : (approvalStatus == 'Pending'
                                        ? Colors.orange.withOpacity(0.8)
                                        : Colors.red.withOpacity(0.8)),
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.w700,
                                fontSize: 18.0),
                          ),
                          Text("$date - $time",
                              style: descriptionStyleDarkBlur3)
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(site, style: subTitleStyle1),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(imgPath),
                            radius: 30,
                          ),
                          //SizedBox(width: 30,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: descriptionStyleDarkBlur,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                content,
                                style: descriptionStyleDark1,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                description,
                                style: descriptionStyleDarkBlur3,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                requestedBy,
                                style: descriptionStyleDarkBlur3,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                approvedBy,
                                style: descriptionStyleDarkBlur3,
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              approvalStatus == 'Pending' && userRole != UserRoles.Securtiy
                  ? Positioned(
                      right: 15,
                      bottom: 0,
                      child: Container(
                        height: 50,
                        width: 180,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              new BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                  spreadRadius: 7),
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Firestore.instance
                                        .collection(collectionName)
                                        .document(documentId)
                                        .updateData({
                                      'approved_by': {
                                        "id": widget.currentUserId,
                                        "name": userName,
                                        "role": userRoleValue,
                                        'at': FieldValue.serverTimestamp(),
                                      },
                                      "status": "Approved",
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green.withOpacity(0.8),
                                    ),
                                    height: 35,
                                    width: 75,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Accept",
                                          style: descriptionStyleLite1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    Firestore.instance
                                        .collection(collectionName)
                                        .document(documentId)
                                        .updateData({
                                      'approved_by': {
                                        "id": widget.currentUserId,
                                        "name": userName,
                                        "role": userRoleValue,
                                        'at': FieldValue.serverTimestamp(),
                                      },
                                      "status": "Declined",
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red.withOpacity(0.8),
                                    ),
                                    height: 35,
                                    width: 75,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Decline",
                                          style: descriptionStyleLite1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}

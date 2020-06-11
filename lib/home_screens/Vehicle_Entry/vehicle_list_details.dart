import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Vehicle_Entry/filter_vehicle_list_details.dart';
import 'package:bhavaniconnect/home_screens/Vehicle_Entry/vehicle_details_readings.dart';
import 'package:bhavaniconnect/home_screens/Vehicle_Entry/add_vehicle_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'vehicle_details_trip.dart';

class DaySelection extends StatefulWidget {
  final String currentUserId;

  const DaySelection({Key key, this.currentUserId}) : super(key: key);

  @override
  _DaySelection createState() => _DaySelection();
}

class _DaySelection extends State<DaySelection> {
  DateTime startFilterDate = DateTimeUtils.currentDayDateTimeNow;
  DateTime endFilterDate =
      DateTimeUtils.currentDayDateTimeNow.add(Duration(days: 1));
  UserRoles userRole;
  String userRoleValue;
  // String userName;

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
      // userName = name;
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
          rightActionBar: (userRole == UserRoles.Manager ||
                  userRole == UserRoles.Accountant ||
                  userRole == UserRoles.Admin)
              ? Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.white,
                )
              : null,
          rightAction: (userRole == UserRoles.Manager ||
                  userRole == UserRoles.Accountant ||
                  userRole == UserRoles.Admin)
              ? () {
                  GoToPage(
                      context,
                      VehicleFilter(
                        startDate: startFilterDate,
                        endDate: endFilterDate,
                      ));
                }
              : null,
          primaryText: 'Vehicle Entries',
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          height: double.infinity,
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection("vehicleEntries")
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
                      return VehicleDetails(
                        size,
                        context,
                        DateTimeUtils.dayMonthYearTimeFormat(
                            (result[index]['added_on'] as Timestamp).toDate()),
                        // "12.30 am",
                        result[index]['construction_site']['constructionSite'],
                        result[index]['dealer']['dealerName'],
                        result[index]['vehicleNumber'],
                        "${result[index]['created_by']['name']} (${result[index]['created_by']['role']})",
                        result[index]['approved_by'] != null
                            ? "${result[index]['approved_by']['name']} (${result[index]['approved_by']['role']})"
                            : "",
                        result[index]['status'] != null
                            ? result[index]['status']
                            : "0",
                        (userRole == UserRoles.Manager ||
                                userRole == UserRoles.Securtiy ||
                                userRole == UserRoles.Admin)
                            ? (result[index]['status'] == "Approved")
                                ? result[index]['vehicleType'] == "Trips"
                                    ? AddVehicleCountDetails(
                                        currentUserId: widget.currentUserId,
                                        documentId: result[index]['documentId'],
                                      )
                                    : AddVehicleDetails(
                                        currentUserId: widget.currentUserId,
                                        documentId: result[index]['documentId'],
                                      )
                                : null
                            : null,
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
                    AddVehicle(
                      currentUserId: widget.currentUserId,
                    ));
              },
              child: Icon(Icons.add),
              backgroundColor: backgroundColor,
            )
          : Container(),
    );
  }
}

Future<void> _showMyDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget VehicleDetails(
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
    Widget goto,
    {double topPadding = 20.0}) {
  return GestureDetector(
    onTap: () {
      goto != null
          ? GoToPage(context, goto)
          : _showMyDialog(
              context,
              (approvalStatus == '2' || approvalStatus == "Declined")
                  ? "Can't open this because it has been rejected"
                  : "Can't open till this has been approved");
    },
    child: Padding(
      padding: EdgeInsets.only(right: 15.0, left: 15, top: topPadding),
      child: Container(
        width: double.infinity,
        height: 240,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 15,
              top: 0,
              child: Text("$date", style: descriptionStyleDarkBlur3), // - $time
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
                    Text("Vehicle: $category", style: subTitleStyle),
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
    ),
  );
}

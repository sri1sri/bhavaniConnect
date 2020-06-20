import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/geo/geo_util.dart';
import 'package:bhavaniconnect/models/current-area.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class AddAttendance extends StatefulWidget {
  final String currentUserId;
  final String documentId;

  const AddAttendance({Key key, this.currentUserId, this.documentId})
      : super(key: key);

  @override
  _AddAttendance createState() => _AddAttendance();
}

class _AddAttendance extends State<AddAttendance> {
  UserRoles userRole;
  String userRoleValue;

  String userName;
  String constructionSiteId;
  String constructionSiteName;

  double siteLatitude;
  double siteLongitude;

  LatLng currentLocation;
  double distance;
  bool inRadius;

  String timestamp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timestamp =
        DateTimeUtils.currentDayDateTimeNow.millisecondsSinceEpoch.toString();
    getUserParams();
  }

  getUserParams() async {
    var prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("userRole");
    String name = prefs.getString("userName");
    String constructionSite = prefs.getString("constructionSite");
    String constructionId = prefs.getString("constructionId");
    double siteLat = prefs.getDouble("siteLatitude");
    double siteLong = prefs.getDouble("siteLongitude");
    getDistance(siteLat, siteLong);

    setState(() {
      userRole = userRoleValues[role];
      userRoleValue = role;
      userName = name;
      siteLatitude = siteLat;
      siteLongitude = siteLong;
      constructionSiteId = constructionId;
      constructionSiteName = constructionSite;
    });
  }

  getCurrentLocation() async {
    await CurrentArea.instance.getCurrentLocation().then((location) async {
      if (location != null) {
        currentLocation = LatLng(location.latitude, location.longitude);
        print(currentLocation);
      }
    });
  }

  getDistance(double lat1, double long1) async {
    await getCurrentLocation();
    setState(() {
      distance = GeoUtil.calcDistance(
          lat1, long1, currentLocation.latitude, currentLocation.longitude);
      inRadius = distance * 1000 <= 50.0;
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
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    String documentId = widget.documentId ?? timestamp + widget.currentUserId;
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
          primaryText: 'Add Attendance',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection(AppConstants.prod + 'attendance')
                .document(documentId)
                .snapshots(),
            builder: (context, snapshot) {
              return Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: backgroundColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15)),
                                height: 120,
                                width: 600,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 35,
                                          color: backgroundColor,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateTimeUtils.weekDayFormat(
                                                  DateTime.now()),
                                              style: descriptionStyleDark,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              DateTimeUtils.formatDayMonthYear(
                                                  DateTime.now()),
                                              style: subTitleStyleDark1,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 2,
                                        height: double.maxFinite,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timer,
                                          size: 35,
                                          color: backgroundColor,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Hours Worked",
                                              style: descriptionStyleDark,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              snapshot.data == null ||
                                                      snapshot.data.data ==
                                                          null ||
                                                      snapshot.data.data[
                                                              'punch_in'] ==
                                                          null ||
                                                      snapshot.data.data[
                                                              'punch_out'] ==
                                                          null
                                                  ? "-"
                                                  : DateTimeUtils
                                                      .getDifferenceTime(
                                                          (snapshot.data.data[
                                                                      'punch_in']
                                                                  as Timestamp)
                                                              .toDate(),
                                                          (snapshot.data.data[
                                                                      'punch_out']
                                                                  as Timestamp)
                                                              .toDate()),
                                              style: subTitleStyleDark1,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: backgroundColor.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height: 100,
                                    width: 180,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.call_received,
                                              size: 35,
                                              color: Colors.green,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Punch In",
                                                  style: descriptionStyleDark,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  snapshot.data == null ||
                                                          snapshot.data.data ==
                                                              null
                                                      ? "-"
                                                      : snapshot.data.data[
                                                                  'punch_in'] ==
                                                              null
                                                          ? "-"
                                                          : DateTimeUtils.hourMinuteFormat(
                                                              (snapshot.data.data[
                                                                          'punch_in']
                                                                      as Timestamp)
                                                                  .toDate()),
                                                  style: subTitleStyleGreen,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: backgroundColor.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height: 100,
                                    width: 180,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.call_made,
                                              size: 35,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Punch Out",
                                                  style: descriptionStyleDark,
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  snapshot.data == null ||
                                                          snapshot.data.data ==
                                                              null
                                                      ? "-"
                                                      : snapshot.data.data[
                                                                  'punch_out'] ==
                                                              null
                                                          ? "-"
                                                          : DateTimeUtils.hourMinuteFormat(
                                                              (snapshot.data.data[
                                                                          'punch_out']
                                                                      as Timestamp)
                                                                  .toDate()),
                                                  style: subTitleStyleRed,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                      widget.documentId == null
                          ? Center(
                              child: AbsorbPointer(
                                absorbing: snapshot.data != null &&
                                    snapshot.data.data != null &&
                                    snapshot.data.data['punch_out'] != null,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                    top: 50,
                                  ),
                                  child: inRadius == null
                                      ? CircularProgressIndicator()
                                      : inRadius
                                          ? ConfirmationSlider(
                                              foregroundShape:
                                                  BorderRadius.circular(15),
                                              backgroundShape:
                                                  BorderRadius.circular(15),
                                              text: snapshot.data == null ||
                                                      snapshot.data.data ==
                                                          null ||
                                                      snapshot.data.data[
                                                              'punch_in'] ==
                                                          null
                                                  ? "      Slide to Punch In"
                                                  : "      Slide to Punch Out",
                                              textStyle: activeSubTitleStyle,
                                              iconColor: Colors.black,
                                              backgroundColor:
                                                  snapshot.data == null ||
                                                          snapshot.data.data ==
                                                              null ||
                                                          snapshot.data.data[
                                                                  'punch_in'] ==
                                                              null
                                                      ? Colors.green
                                                      : Colors.red,
                                              foregroundColor: Colors.white,
                                              onConfirmation: () async {
                                                if (snapshot.data == null ||
                                                    snapshot.data.data ==
                                                        null ||
                                                    snapshot.data
                                                            .data['punch_in'] ==
                                                        null) {
                                                  try {
                                                    await Firestore.instance
                                                        .collection(
                                                            AppConstants.prod +
                                                                'attendance')
                                                        .document(documentId)
                                                        .setData({
                                                      'created_by': {
                                                        "id": widget
                                                            .currentUserId,
                                                        "name": userName,
                                                        "role": userRoleValue,
                                                      },
                                                      'documentId': documentId,
                                                      'construction_site': {
                                                        "constructionId":
                                                            constructionSiteId,
                                                        "constructionSite":
                                                            constructionSiteName,
                                                      },
                                                      'punch_in': FieldValue
                                                          .serverTimestamp(),
                                                    });
                                                    Navigator.pop(context);
                                                  } catch (err) {
                                                    setState(() {
                                                      // isProcessing = false;
                                                      // error = err;
                                                    });
                                                  } finally {
                                                    if (mounted) {
                                                      setState(() {
                                                        // isProcessing = false;
                                                      });
                                                    }
                                                  }
                                                } else if (snapshot.data
                                                        .data['punch_out'] ==
                                                    null) {
                                                  try {
                                                    await Firestore.instance
                                                        .collection(
                                                            AppConstants.prod +
                                                                'attendance')
                                                        .document(documentId)
                                                        .updateData({
                                                      'punch_out': FieldValue
                                                          .serverTimestamp(),
                                                    });
                                                    Navigator.pop(context);
                                                  } catch (err) {
                                                    setState(() {
                                                      // isProcessing = false;
                                                      // error = err;
                                                    });
                                                  } finally {
                                                    if (mounted) {
                                                      setState(() {
                                                        // isProcessing = false;
                                                      });
                                                    }
                                                  }
                                                }
                                              },
                                            )
                                          : Text(
                                              "You are not in construction Site",
                                              style: subTitleStyleDark1,
                                            ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget attendanceCard(
      String day, String month, String year, String inTime, String outTime) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15)),
            height: 90,
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: titleStylelight,
                ),
                Text(
                  month,
                  style: descriptionStyleLite1,
                ),
                Text(
                  year,
                  style: descriptionStyleLite1,
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          inRadius == null
              ? CircularProgressIndicator()
              : inRadius
                  ? Container(
                      decoration: BoxDecoration(
                          color: backgroundColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15)),
                      height: 90,
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.call_received,
                                size: 30,
                                color: Colors.green,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Punch In",
                                    style: descriptionStyleDark,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    inTime,
                                    style: subTitleStyleDark1,
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 2,
                              height: double.maxFinite,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.call_made,
                                size: 30,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Punch Out",
                                    style: descriptionStyleDark,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    outTime,
                                    style: subTitleStyleDark1,
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Text(
                      "You are not in site location, please go to $constructionSiteName",
                      style: subTitleStyleDark1,
                    ),
        ],
      ),
    );
  }
}

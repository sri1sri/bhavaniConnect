import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String currentUserId;

  const ProfilePage(this.currentUserId);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _n = 0;
  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  @override
  void initState() {
    super.initState();
    print(widget.currentUserId);
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
        preferredSize: Size.fromHeight(60),
        child: CustomAppBarDark(
          primaryText: 'Profile',
          tabBarWidget: null,
          leftActionBar: Icon(
            Icons.notifications,
            size: 30,
            color: Colors.transparent,
          ),
          rightActionBar: Icon(
            Icons.settings,
            size: 25,
            color: Colors.white,
          ),
          rightAction: () {
            GoToPage(
              context,
              SettingsPage(),
            );
          },
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0), topLeft: Radius.circular(40.0)),
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("userData")
                    .document(widget.currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue)));
                  } else {
                    var result = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(result['avatar']),
                              radius: 80,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: descriptionStyleDarkBlur1,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              result['name'],
                              style: subTitleStyleDark1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Contact No.",
                              style: descriptionStyleDarkBlur1,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              result['phoneNumber'],
                              style: subTitleStyleDark1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Date of Birth",
                              style: descriptionStyleDarkBlur1,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              DateTimeUtils.formatDayMonthYear(
                                  (result["date_of_birth"] as Timestamp)
                                      .toDate()),
                              style: subTitleStyleDark1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Gender",
                              style: descriptionStyleDarkBlur1,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              result['gender'] == 1 ? "Male" : "Female",
                              style: subTitleStyleDark1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Role",
                              style: descriptionStyleDarkBlur1,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              result['role'],
                              style: subTitleStyleDark1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Site",
                              style: descriptionStyleDarkBlur1,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              result['construction_site']['constructionSite'],
                              style: subTitleStyleDark1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Date of Joining",
                              style: descriptionStyleDarkBlur1,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              DateTimeUtils.formatDayMonthYear(
                                  (result["joinedDate"] as Timestamp).toDate()),
                              style: subTitleStyleDark1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        )
                      ],
                    );
                  }
                }),
          )),
        ),
      ),
    );
  }
}

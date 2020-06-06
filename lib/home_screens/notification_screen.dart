import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_NotificationPage(),
    );
  }
}

class F_NotificationPage extends StatefulWidget {
  @override
  _F_NotificationPageState createState() => _F_NotificationPageState();
}

class _F_NotificationPageState extends State<F_NotificationPage> {
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
          child: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              NotificationCard(
                  size,
                  context,
                  "Approved",
                  "29/Oct/2020",
                  "10.30am",
                  "Bhavani Vivan",
                  "images/s3.png",
                  "Vehicle Entry",
                  "TN66V6571 - Goods Truck",
                  "Sand load 2 tons for 2nd block"),
              NotificationCard(
                  size,
                  context,
                  "Pending",
                  "30/Oct/2020",
                  "12.22pm",
                  "Bhavani Aravindam",
                  "images/s3.png",
                  "Goods Approval",
                  "Iron/Steel - Goods",
                  "8 Layers SuperStrong Tmt rods"),
              NotificationCard(
                  size,
                  context,
                  "Declined",
                  "31/Oct/2020",
                  "04.42pm",
                  "Bhavani Vivan",
                  "images/s3.png",
                  "Vehicle Entry",
                  "AP66Y7263 - Road Roller",
                  "2 units of trip counts"),
              SizedBox(
                height: 700,
              )
            ],
          )),
        ),
      ),
    );
  }
}

Widget NotificationCard(
    Size size,
    BuildContext context,
    String approvalStatus,
    String date,
    String time,
    String site,
    String imgPath,
    String title,
    String content,
    String description) {
  return GestureDetector(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 15, top: 20),
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
                height: 190,
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
                        Text("$date - $time", style: descriptionStyleDarkBlur3)
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
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            approvalStatus == 'Pending'
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
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.green.withOpacity(0.8),
                                  ),
                                  height: 35,
                                  width: 75,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.red.withOpacity(0.8),
                                  ),
                                  height: 35,
                                  width: 75,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
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

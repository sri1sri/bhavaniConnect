import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Attendance/Display_Attendance.dart';
import 'package:bhavaniconnect/home_screens/Goods_Approval/Display_Goods.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/site_Activities_HomePage.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/showAllInvoice.dart';
import 'package:bhavaniconnect/home_screens/Vehicle_Entry/vehicle_list_details.dart';
import 'package:bhavaniconnect/home_screens/badge_icon.dart';
import 'package:bhavaniconnect/home_screens/notification_screen.dart';
import 'package:bhavaniconnect/models/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Add_Stock/Stock_Screen.dart';
import 'Concrete_Entries/Concrete_HomePage.dart';
import 'Labour_Report/Daily_labour_Report.dart';

class Dashboard extends StatefulWidget {
  final String currentUserId;

  const Dashboard({
    Key key,
    this.currentUserId,
  }) : super(key: key);
  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  var features = [
    "Approvals",
    "Catalog",
//    "Store",
//    "Inventory",
    "Attendance",
//    "Employees",
    "Vehicle Entries",
    "Stock Register",
    "Site Activities",
    "Concrete Entries",
    "Labour Report"
  ];
  List<String> F_image = [
    "images/Approval.jpg",
    "images/Addstock.jpg",
//    "images/store.jpg",
//    "images/inventory.png",
    "images/Attendance.jpg",
//    "images/ManageEmployees.jpg",
    "images/jcb.png",
    "images/invoice.png",
    "images/siteActivity.png",
    "images/Concrete.png",
    "images/LabourReport.png",
  ];

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
          primaryText: 'Home',
          tabBarWidget: null,
          leftActionBar: Icon(
            Icons.notifications,
            size: 30,
            color: Colors.transparent,
          ),
          rightActionBar: Consumer<NotificationModel>(
            builder: (context, model, child) {
              return BadgeIcon(
                icon: Icon(
                  Icons.notifications,
                  size: 25,
                  color: Colors.white,
                ),
                badgeCount: model.count,
              );
            },
          ),
          rightAction: () {
            GoToPage(
              context,
              NotificationPage(currentUserId: widget.currentUserId),
            );
          },
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.37,
                    child: GridView.builder(
                      itemCount: features.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.99,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 5.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                          child: new Card(
                            elevation: 0.0,
                            child: new Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6.0,
                                        spreadRadius: 5),
                                  ]),
                              alignment: Alignment.center,
                              margin: new EdgeInsets.only(
                                  top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                              child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    F_image[index],
                                    height: 60,
                                  ),
                                  new Text(
                                    features[index],
                                    style: subTitleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            switch (features[index]) {
//                        case 'Employees':
//                          {
//                            GoToPage(
//                                context,
//                                ManageEmployeesPage(
//                                  database: widget.database,
//                                  employee: employee,
//                                ));
//                          }
//                          break;
//
                              case 'Approvals':
                                {
                                  GoToPage(
                                      context,
                                      GoodsScreen(
                                        currentUserId: widget.currentUserId,
                                      ));
                                }
                                break;
//                        case 'Store':
//                          {
//                            GoToPage(
//                                context,
//                                StorePage(
//                                  database: widget.database,
//                                  employee: employee,
//                                ));
//                          }
//                          break;
//
//                        case 'Inventory':
//                          {
//                            GoToPage(
//                              context,
//                              InventoryPage(database: widget.database,),
//                            );
//                          }
//                          break;
//
                              case 'Attendance':
                                {
                                  GoToPage(
                                    context,
                                    DisplayAttendance(
                                      currentUserId: widget.currentUserId,
                                    ),
                                  );
                                }
                                break;
                              case 'Catalog':
                                {
                                  GoToPage(
                                      context,
                                      StockScreen(
                                        currentUserId: widget.currentUserId,
                                      ));
                                }
                                break;
                              case 'Vehicle Entries':
                                {
                                  GoToPage(
                                      context,
                                      DaySelection(
                                        currentUserId: widget.currentUserId,
                                      ));
                                }
                                break;
                              case 'Stock Register':
                                {
                                  GoToPage(
                                      context,
                                      ShowAllInvoice(
                                          currentUserId: widget.currentUserId));
                                }
                                break;
                              case 'Site Activities':
                                {
                                  GoToPage(
                                      context,
                                      SiteActivities(
                                        currentUserId: widget.currentUserId,
                                      ));
                                }
                                break;
                              case 'Concrete Entries':
                                {
                                  GoToPage(
                                      context,
                                      ConcreteEntries(
                                        currentUserId: widget.currentUserId,
                                      ));
                                }
                                break;
                              case 'Labour Report':
                                {
                                  GoToPage(
                                      context,
                                      LabourEntries(
                                        currentUserId: widget.currentUserId,
                                      ));
                                }
                                break;

                              default:
                                {}
                                break;
                            }
                          },
                        );
                      },
                    ),
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

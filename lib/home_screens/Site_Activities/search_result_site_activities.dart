import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/no_data_widget.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_page.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/add_Site_Activity.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/detail_description.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/print_Activity.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/search_Activity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class SearchResultActivities extends StatefulWidget {
  final String currentUserId;
  final String selectedConstructionId;
  final String selectedConstructionSite;
  final String selectedBlock;
  final String selectedBlockId;
  final String selectedCategoryId;
  final String selectedCategory;
  final String selectedSubCategory;
  final String selectedSubCategoryId;

  const SearchResultActivities({
    Key key,
    this.currentUserId,
    this.selectedConstructionId,
    this.selectedConstructionSite,
    this.selectedBlock,
    this.selectedBlockId,
    this.selectedCategoryId,
    this.selectedCategory,
    this.selectedSubCategory,
    this.selectedSubCategoryId,
  }) : super(key: key);

  @override
  _SearchResultActivitiesState createState() => _SearchResultActivitiesState();
}

class _SearchResultActivitiesState extends State<SearchResultActivities> {
  int _n = 0;

  DateTime startFilterDate = DateTime(2010);
  DateTime endFilterDate =
      DateTimeUtils.currentDayDateTimeNow.add(Duration(days: 1));

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
                  height: getDynamicHeight(50),
                ),
                Container(
                  height: getDynamicHeight(80),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 45,
                          left: 20,
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
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Center(
                            child: Text(
                              "Search Activities",
                              textAlign: TextAlign.center,
                              style: appBarTitleStyle,
                            ),
                          ),
                        ),
                      ),
                      // Padding(
                      //     padding: EdgeInsets.only(
                      //       top: 35,
                      //       right: 20,
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         IconButton(
                      //           icon: Icon(
                      //             Icons.search,
                      //             size: 25,
                      //             color: Colors.white,
                      //           ),
                      //           onPressed: () {
                      //             GoToPage(context, SearchActivity());
                      //           },
                      //         ),
                      //         userRole != null &&
                      //                 (userRole == UserRoles.Admin ||
                      //                     userRole == UserRoles.Manager ||
                      //                     userRole == UserRoles.Accountant ||
                      //                     userRole == UserRoles.SiteEngineer)
                      //             ? IconButton(
                      //                 icon: Icon(
                      //                   Icons.print,
                      //                   size: 25,
                      //                   color: Colors.white,
                      //                 ),
                      //                 onPressed: () {
                      //                   GoToPage(
                      //                       context,
                      //                       PrintActivity(
                      //                         startDate: startFilterDate,
                      //                         endDate: endFilterDate,
                      //                       ));
                      //                 },
                      //               )
                      //             : Container(),
                      //       ],
                      //     )),
                    ],
                  ),
                ),
              ],
            ),
          )),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: userRole != null && userRole != UserRoles.Securtiy
            ? Container(
                height: double.infinity,
                color: Colors.white,
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection(AppConstants.prod + "siteActivities")
                        .where("construction_site.constructionId",
                            isEqualTo: widget.selectedConstructionId)
                        .where('block.blockId',
                            isEqualTo: widget.selectedBlockId)
                        .where("category.selectedCategoryId",
                            isEqualTo: widget.selectedCategoryId)
                        .where('sub_category.selectedSubCategoryId',
                            isEqualTo: widget.selectedSubCategoryId)
                        // .where("added_on", isGreaterThan: startFilterDate)
                        // .where("added_on", isLessThan: endFilterDate)
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
                            return SiteActivity(
                              size,
                              context,
                              result[index].documentID,
                              widget.currentUserId,
                              DateTimeUtils.dayMonthYearTimeFormat(
                                  (result[index]['added_on'] as Timestamp)
                                      .toDate()),
                              result[index]['construction_site']
                                  ['constructionSite'],
                              "28 Tons of TMT rods with steel blend.",
                              result[index]['category']['categoryName'],
                              result[index]['sub_category']['subCategoryName'],
                              result[index]['block']['blockName'],
                              result[index]['total_progress'].toString(),
                              topPadding: index == 0 ? 40 : 20,
                            );
                          },
                        );
                      }
                    }),
              )
            : OfflinePage(
                text: "you don’t have access\nto this page",
                color: Colors.white,
              ),
      ),
      floatingActionButton: userRole != null &&
              (userRole == UserRoles.Admin ||
                  userRole == UserRoles.Manager ||
                  userRole == UserRoles.SiteEngineer)
          ? FloatingActionButton(
              onPressed: () {
                GoToPage(
                    context,
                    AddSiteActivity(
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
  String date;
  String createdBy;
  String site;
  String block;
  String category;
  String uom;
  String subCategory;
  String yesterdayProg;
  String totalProg;
  String remarks;

  ItemInfo({
    this.slNo,
    this.createdBy,
    this.date,
    this.site,
    this.category,
    this.uom,
    this.block,
    this.subCategory,
    this.yesterdayProg,
    this.totalProg,
    this.remarks,
  });
}

// var items = <ItemInfo>[
//   ItemInfo(
//       slNo: '1',
//       createdBy: "Vasanth (Manager)",
//       date: '29/Oct/2020',
//       site: 'Bhavani Vivan',
//       block: "8th",
//       category: 'Iron/Steel',
//       subCategory: 'TMT rod',
//       uom: 'Tons',
//       yesterdayProg: "20",
//       totalProg: "60",
//       remarks: 'Transfer from store to cnstruction Site'),
//   ItemInfo(
//       slNo: '2',
//       date: '29/Oct/2020',
//       site: 'Bhavani Vivan',
//       createdBy: "Vasanth (Manager)",
//       block: "8th",
//       category: 'Iron/Steel',
//       subCategory: 'TMT rod',
//       uom: 'Tons',
//       yesterdayProg: "20",
//       totalProg: "60",
//       remarks: 'Transfer from store to cnstruction Site'),
//   ItemInfo(
//       slNo: '3',
//       date: '29/Oct/2020',
//       createdBy: "Vasanth (Manager)",
//       site: 'Bhavani Vivan',
//       block: "8th",
//       category: 'Iron/Steel',
//       subCategory: 'TMT rod',
//       uom: 'Tons',
//       yesterdayProg: "20",
//       totalProg: "60",
//       remarks: 'Transfer from store to cnstruction Site'),
//   ItemInfo(
//       slNo: '3',
//       date: '29/Oct/2020',
//       site: 'Bhavani Vivan',
//       createdBy: "Vasanth (Manager)",
//       block: "8th",
//       category: 'Iron/Steel',
//       subCategory: 'TMT rod',
//       uom: 'Tons',
//       yesterdayProg: "20",
//       totalProg: "60",
//       remarks: 'Transfer from store to cnstruction Site'),
//   ItemInfo(
//       slNo: '4',
//       createdBy: "Vasanth (Manager)",
//       date: '29/Oct/2020',
//       site: 'Bhavani Vivan',
//       block: "8th",
//       category: 'Iron/Steel',
//       subCategory: 'TMT rod',
//       uom: 'Tons',
//       yesterdayProg: "20",
//       totalProg: "60",
//       remarks: 'Transfer from store to cnstruction Site'),
// ];

Widget SiteActivity(
    Size size,
    BuildContext context,
    String documentId,
    String currentUserId,
    String date,
    String site,
    String description,
    String category,
    String subCat,
    String block,
    String total,
    {double topPadding = 20.0}) {
  return GestureDetector(
    onTap: () {
      GoToPage(
          context,
          ActivityDetailDescription(
            currentUserId: currentUserId,
            documentId: documentId,
          ));
    },
    child: Padding(
      padding: EdgeInsets.only(right: 15.0, left: 15, top: topPadding),
      child: Container(
        width: double.infinity,
        height:getDynamicHeight(210),
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
                height: getDynamicHeight(185),
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
                      "Block: $block",
                      style: descriptionStyleDarkBlur1,
                    ),
                    SizedBox(height: getDynamicHeight(10),),
                    Expanded(
                      child: Text(description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleStyleDark1),
                    ),
                    Text('$category - $subCat', style: subTitleStyle),
                    SizedBox(height: getDynamicHeight(10),),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: getDynamicHeight(50),
                width: size.width * .40,
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
                  child: Text("Progress: $total", style: subTitleStyleLight),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

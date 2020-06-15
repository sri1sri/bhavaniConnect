import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/Entry_description.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/Print_entries.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/add_concrete_entry.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConcreteEntries extends StatefulWidget {
  final String currentUserId;

  const ConcreteEntries({Key key, this.currentUserId}) : super(key: key);
  @override
  _ConcreteEntries createState() => _ConcreteEntries();
}

class _ConcreteEntries extends State<ConcreteEntries> {
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
        child: CustomAppBarDark(
          leftActionBar: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.white,
          ),
          leftAction: () {
            Navigator.pop(context, true);
          },
          rightActionBar: userRole != null &&
                  (userRole == UserRoles.Admin ||
                      userRole == UserRoles.Manager ||
                      userRole == UserRoles.StoreManager ||
                      userRole == UserRoles.Accountant)
              ? Icon(
                  Icons.print,
                  size: 25,
                  color: Colors.white,
                )
              : Container(height: 0, width: 0),
          rightAction: () {
            GoToPage(
                context,
                PrintEntries(
                  startDate: DateTimeUtils.currentDayDateTimeNow,
                  endDate: endFilterDate,
                ));
          },
          primaryText: 'Concrete Entries',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: userRole != null && userRole != UserRoles.Securtiy
            ? Container(
                color: Colors.white,
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection("concreteEntries")
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
                            return ConcreteEntry(
                              size,
                              context,
                              result[index].documentID,
                              widget.currentUserId,
                              DateTimeUtils.dayMonthYearTimeFormat(
                                  (result[index]['added_on'] as Timestamp)
                                      .toDate()),
                              result[index]['construction_site']
                                  ['constructionSite'],
                              result[index]['concrete_type']
                                  ['concreteTypeName'],
                              result[index]['block']['blockName'],
                              result[index]['total_progress'],
                              topPadding: index == 0 ? 40 : 20,
                            );
                          },
                        );
                      }
                    }),
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: Center(
                  child: Text(
                    "No access widget",
                    style: titleStyle,
                  ),
                ),
              ),
      ),
      floatingActionButton: userRole != null &&
              (userRole == UserRoles.Admin ||
                  userRole == UserRoles.Manager ||
                  userRole == UserRoles.StoreManager)
          ? FloatingActionButton(
              onPressed: () {
                GoToPage(
                    context,
                    AddConcreteEntry(
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
  String createdBy;
  String date;
  String site;
  String block;
  String concreteType;
  String yestProg;
  String totalProg;
  String remarks;

  ItemInfo({
    this.slNo,
    this.date,
    this.createdBy,
    this.site,
    this.block,
    this.concreteType,
    this.yestProg,
    this.totalProg,
    this.remarks,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      concreteType: "Strong Cement",
      block: "8th",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '2',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '3',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '4',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
  ItemInfo(
      slNo: '5',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'),
];

Widget ConcreteEntry(
    Size size,
    BuildContext context,
    String documentId,
    String currentUserId,
    String date,
    String site,
    String concreteType,
    String block,
    String total,
    {double topPadding = 20.0}) {
  return GestureDetector(
    onTap: () {
      GoToPage(
          context,
          EntryDescription(
            currentUserId: currentUserId,
            documentId: documentId,
          ));
    },
    child: Padding(
      padding: EdgeInsets.only(right: 15.0, left: 15, top: topPadding),
      child: Container(
        width: double.infinity,
        height: 190,
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
                height: 165,
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
                      "Block: $block",
                      style: descriptionStyleDarkBlur1,
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Text(concreteType,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleStyleDark1),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: 50,
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

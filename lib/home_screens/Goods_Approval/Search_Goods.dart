import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/Stock_Data_List.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

import 'Filtered_Goods.dart';

class GoodsFilter extends StatefulWidget {

  @override
  _GoodsFilter createState() => _GoodsFilter();
}

class _GoodsFilter extends State<GoodsFilter> {
  DateTime selectedDateFrom;
  DateTime selectedDateTo;

  String constructionId;
  String selectedConstructionSite;

  String selectedDealerId;
  String selectedDealer;

  String selectedCategory;
  String selectedCategoryId;

  bool validated = false;

  @override
  void initState() {
    super.initState();
    selectedDateFrom = DateTime.now();
    selectedDateTo = DateTime.now();
  }

//  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
//  var customFormat2 = DateFormat("dd MMM yyyy");
//  Future<Null> showPickerFrom(BuildContext context) async {
//    final DateTime pickedFrom = await showDatePicker(
//      context: context,
//      initialDate: selectedDateFrom,
//      firstDate: DateTime(1930),
//      lastDate: selectedDateTo,
//    );
//    if (pickedFrom != null) {
//      setState(() {
//        print(customFormat.format(pickedFrom));
//        selectedDateFrom = pickedFrom;
//      });
//    }
//  }
//
//  Future<Null> showPickerTo(BuildContext context) async {
//    final DateTime pickedTo = await showDatePicker(
//      context: context,
//      initialDate: selectedDateTo,
//      firstDate: selectedDateFrom,
//      lastDate: DateTimeUtils.currentDayDateTimeNow.add(Duration(days: 1)),
//    );
//    if (pickedTo != null) {
//      setState(() {
//        print(customFormat.format(pickedTo));
//        selectedDateTo = pickedTo;
//      });
//    }
//  }

  final _formKey = GlobalKey<FormState>();
  bool visible = true;
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
          rightActionBar: Container(
            width: getDynamicHeight(10),
          ),
          rightAction: () {
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Search Goods',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: getDynamicHeight(50),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Construction Site",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: getDynamicHeight(15),
                              ),
                              DropdownSearch(
                                showSelectedItem: true,
                                maxHeight: 400,
                                mode: Mode.MENU,
                                items: [
                                  "Bhavani vivan",
                                  "Bhavani Aravindham",
                                ],
                                label: "All Construction sites Selected",
                                onChanged: print,
                                selectedItem: "Choose Construction site",
                                showSearchBox: true,
                                validate: (value) => value == null
                                    ? 'Construction site cannot be empty'
                                    : null,
                              ),
                              SizedBox(
                                height: getDynamicHeight(20),
                              ),
                              Text(
                                "Dealer Name",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: getDynamicHeight(15),
                              ),
                              DropdownSearch(
                                showSelectedItem: true,
                                maxHeight: 400,
                                mode: Mode.MENU,
                                items: [
                                  "dealer 1",
                                  "dealer 2",
                                ],
                                label: "All Dealer Selected",
                                onChanged: print,
                                selectedItem: "Choose Dealer",
                                showSearchBox: true,
                                validate: (value) => value == null
                                    ? 'Dealer cannot be empty'
                                    : null,
                              ),
                              SizedBox(
                                height: getDynamicHeight(20),
                              ),
                              Text(
                                "Category",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: getDynamicHeight(15),
                              ),
                              DropdownSearch(
                                showSelectedItem: true,
                                maxHeight: 400,
                                mode: Mode.MENU,
                                items: [
                                  "Category 1",
                                  "category 2",
                                ],
                                label: "All Category Selected",
                                onChanged: print,
                                selectedItem: "Choose Category",
                                showSearchBox: true,
                                validate: (value) => value == null
                                    ? 'Category cannot be empty'
                                    : null,
                              ),
                              SizedBox(
                                height: getDynamicHeight(20),
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width / 2 -
                                        25,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "From",
                                          style: titleStyle,
                                        ),
                                        SizedBox(
                                          height: getDynamicHeight(15),
                                        ),
                                        GestureDetector(
                                          //onTap: () => showPickerFrom(context),
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  size: 18.0,
                                                  color: backgroundColor,
                                                ),
                                                SizedBox(
                                                  width: getDynamicWidth(10),
                                                ),
                                                Text(
                                                  '22/03/2010',
//                                                    '${customFormat2.format(selectedDateFrom)}',
                                                    style: subTitleStyle),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width:
                                    MediaQuery.of(context).size.width / 2 -
                                        25,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "To",
                                          style: titleStyle,
                                        ),
                                        SizedBox(
                                          height: getDynamicHeight(15),
                                        ),
                                        GestureDetector(
                                          //onTap: () => showPickerTo(context),
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.date_range,
                                                  size: 18.0,
                                                  color: backgroundColor,
                                                ),
                                                SizedBox(
                                                  width: getDynamicWidth(10),
                                                ),
                                                Text(
                                                    '22/03/2010',
//                                                    '${customFormat2.format(selectedDateTo)}',
                                                    style: subTitleStyle),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: getDynamicHeight(30),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: getDynamicHeight(55),
                              width: getDynamicWidth(180),
                              child: GestureDetector(
                                onTap: ()
                                {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PrintPreviewGoods(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child:Text(
                                          "Search",
                                          style: activeSubTitleStyle,
                                        )
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 500,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

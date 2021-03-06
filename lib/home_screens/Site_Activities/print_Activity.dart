import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/print_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class PrintActivity extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const PrintActivity({Key key, this.startDate, this.endDate})
      : super(key: key);
  @override
  _PrintActivity createState() => _PrintActivity();
}

class _PrintActivity extends State<PrintActivity> {
  DateTime selectedDateFrom = DateTime(2010);
  DateTime selectedDateTo = DateTime(2010);
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");

  bool validated = false;

  String selectedConstructionSite;
  String selectedConstructionId;

  String selectedBlock;
  String selectedBlockId;

  String selectedCategory;
  String selectedCategoryId;

  String selectedSubCategory;
  String selectedSubCategoryId;

  @override
  void initState() {
    super.initState();

    selectedDateFrom = widget.startDate;
    selectedDateTo = widget.endDate;
  }

  Future<Null> showPickerFrom(BuildContext context) async {
    final DateTime pickedFrom = await showDatePicker(
      context: context,
      initialDate: selectedDateFrom,
      firstDate: DateTime(1930),
      lastDate: selectedDateFrom,
    );
    if (pickedFrom != null) {
      setState(() {
        print(customFormat.format(pickedFrom));
        selectedDateFrom = pickedFrom;
      });
    }
  }

  Future<Null> showPickerTo(BuildContext context) async {
    final DateTime pickedTo = await showDatePicker(
      context: context,
      initialDate: selectedDateTo,
      firstDate: DateTime(1930),
      lastDate: selectedDateTo,
    );
    if (pickedTo != null) {
      setState(() {
        print(customFormat.format(pickedTo));
        selectedDateTo = pickedTo;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
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
            width: 10,
          ),
          rightAction: () {
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Print Activity',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: getDynamicHeight(20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Construction Site",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(
                                    AppConstants.prod + "constructionSite")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                List<String> items = snapshot.data.documents
                                    .map((e) => (e.documentID.toString()))
                                    .toList();
                                return DropdownSearch(
                                  showSelectedItem: true,
                                  maxHeight: 400,
                                  mode: Mode.MENU,
                                  items: items,
                                  dropdownItemBuilder:
                                      (context, value, isTrue) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents
                                          .firstWhere((element) =>
                                              element.documentID ==
                                              value)['name']
                                          .toString()),
                                      selected: isTrue,
                                      onTap: () {
                                        setState(() {
                                          selectedConstructionSite = snapshot
                                              .data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString();
                                          selectedConstructionId = value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  label: "Construction Site",
                                  onChanged: (value) {},
                                  selectedItem: selectedConstructionSite ??
                                      "All construction sites selected",
                                  showSearchBox: true,
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Block",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          DropdownSearch(
                            showSelectedItem: true,
                            maxHeight: 400,
                            mode: Mode.MENU,
                            items: AppConstants.blockType,
                            dropdownItemBuilder: (context, value, isTrue) {
                              return ListTile(
                                title: Text(value),
                                selected: isTrue,
                                onTap: () {
                                  setState(() {
                                    selectedBlock = value;
                                    selectedBlockId = value;
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            label: "Block",
                            onChanged: (value) {},
                            selectedItem: selectedBlock ?? "All block selected",
                            showSearchBox: true,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Category",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(AppConstants.prod + "category")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                List<String> items = snapshot.data.documents
                                    .map((e) => (e.documentID.toString()))
                                    .toList();
                                return DropdownSearch(
                                  showSelectedItem: true,
                                  maxHeight: 400,
                                  mode: Mode.MENU,
                                  items: items,
                                  dropdownItemBuilder:
                                      (context, value, isTrue) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents
                                          .firstWhere((element) =>
                                              element.documentID ==
                                              value)['name']
                                          .toString()),
                                      selected: isTrue,
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = snapshot
                                              .data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString();
                                          selectedCategoryId = value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  label: "Category",
                                  onChanged: (value) {},
                                  selectedItem: selectedCategory ??
                                      "All category selected",
                                  showSearchBox: true,
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Sub Category",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(AppConstants.prod + "subCategory")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                List<String> items = snapshot.data.documents
                                    .map((e) => (e.documentID.toString()))
                                    .toList();
                                return DropdownSearch(
                                  showSelectedItem: true,
                                  maxHeight: 400,
                                  mode: Mode.MENU,
                                  items: items,
                                  dropdownItemBuilder:
                                      (context, value, isTrue) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents
                                          .firstWhere((element) =>
                                              element.documentID ==
                                              value)['name']
                                          .toString()),
                                      selected: isTrue,
                                      onTap: () {
                                        setState(() {
                                          selectedSubCategory = snapshot
                                              .data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString();
                                          selectedSubCategoryId = value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  label: "Sub Category",
                                  onChanged: (value) {},
                                  selectedItem: selectedSubCategory ??
                                      "All sub category selected",
                                  showSearchBox: true,
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "From",
                                      style: titleStyle,
                                    ),
                                    SizedBox(
                                      height: getDynamicHeight(15),
                                    ),
                                    GestureDetector(
                                      onTap: () => showPickerFrom(context),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              size: 18.0,
                                              color: backgroundColor,
                                            ),
                                            SizedBox(
                                              width: getDynamicHeight(10),
                                            ),
                                            Text(
                                                '${customFormat2.format(selectedDateFrom)}',
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
                                    MediaQuery.of(context).size.width / 2 - 25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "To",
                                      style: titleStyle,
                                    ),
                                    SizedBox(
                                      height: getDynamicHeight(15),
                                    ),
                                    GestureDetector(
                                      onTap: () => showPickerTo(context),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              size: 18.0,
                                              color: backgroundColor,
                                            ),
                                            SizedBox(
                                              width: getDynamicHeight(10),
                                            ),
                                            Text(
                                                '${customFormat2.format(selectedDateTo)}',
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
                      height: getDynamicHeight(20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: getDynamicHeight(55),
                          width: getDynamicWidth(180),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrintPreview(
                                    selectedDateFrom,
                                    selectedDateTo,
                                    selectedConstructionId,
                                    selectedConstructionSite,
                                    selectedBlockId,
                                    selectedBlock,
                                    selectedCategoryId,
                                    selectedCategory,
                                    selectedSubCategoryId,
                                    selectedSubCategory,
                                  ),
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
                                    child: Text(
                                      "Preview",
                                      style: activeSubTitleStyle,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getDynamicHeight(300),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

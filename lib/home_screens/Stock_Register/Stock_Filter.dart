import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/Stock_Data_List.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StockFilter extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String constructionId;
  final String dealerId;
  final String categoryId;
  final String itemId;
  final Function(DateTime startDate, DateTime endDate, String constructionId,
      String dealerId, String categoryId, String itemId) returnFunction;

  const StockFilter(
      {Key key,
      this.startDate,
      this.endDate,
      this.constructionId,
      this.dealerId,
      this.itemId,
      this.categoryId,
      this.returnFunction})
      : super(key: key);

  @override
  _StockFilter createState() => _StockFilter();
}

class _StockFilter extends State<StockFilter> {
  DateTime selectedDateFrom;
  DateTime selectedDateTo;

  String constructionId;
  String selectedConstructionSite;

  String selectedDealerId;
  String selectedDealer;

  String selectedItemId;
  String selectedItem;

  String selectedCategory;
  String selectedCategoryId;

  bool validated = false;

  @override
  void initState() {
    super.initState();

    selectedDateFrom = widget.startDate;
    selectedDateTo = widget.endDate;
    constructionId = widget.constructionId;
    selectedDealerId = widget.dealerId;
    selectedItemId = widget.itemId;
    selectedCategoryId = widget.categoryId;
  }

  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");
  Future<Null> showPickerFrom(BuildContext context) async {
    final DateTime pickedFrom = await showDatePicker(
      context: context,
      initialDate: selectedDateFrom,
      firstDate: DateTime(1930),
      lastDate: selectedDateTo,
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
      firstDate: selectedDateFrom,
      lastDate: DateTimeUtils.currentDayDateTimeNow.add(Duration(days: 1)),
    );
    if (pickedTo != null) {
      setState(() {
        print(customFormat.format(pickedTo));
        selectedDateTo = pickedTo;
      });
    }
  }

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
            width: 10,
          ),
          rightAction: () {
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Search Stock',
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
                          height: 50,
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
                                height: 15,
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection("constructionSite")
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
                                              selectedConstructionSite =
                                                  snapshot.data.documents
                                                      .firstWhere((element) =>
                                                          element.documentID ==
                                                          value)['name']
                                                      .toString();
                                              constructionId = value;
                                              print(constructionId);
                                              print(selectedConstructionSite);
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
                                height: 20,
                              ),
                              Text(
                                "Dealer Name",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection("dealer")
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
                                              selectedDealer = snapshot
                                                  .data.documents
                                                  .firstWhere((element) =>
                                                      element.documentID ==
                                                      value)['name']
                                                  .toString();
                                              selectedDealerId = value;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      label: "Dealer Name",
                                      onChanged: (value) {},
                                      selectedItem: selectedDealer ??
                                          "All dealer selected",
                                      showSearchBox: true,
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Category",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection("category")
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
                                height: 20,
                              ),
                              Text(
                                "Item Name",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection("items")
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
                                              selectedItem = snapshot
                                                  .data.documents
                                                  .firstWhere((element) =>
                                                      element.documentID ==
                                                      value)['name']
                                                  .toString();
                                              selectedItemId = value;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      label: "Item Name",
                                      onChanged: (value) {},
                                      selectedItem:
                                          selectedItem ?? "All item selected",
                                      showSearchBox: true,
                                      // validate: (value) {
                                      //   if (validated &&
                                      //       (selectedItem == null ||
                                      //           selectedItem.isEmpty)) {
                                      //     return "Item Description cannot be empty";
                                      //   } else {
                                      //     return null;
                                      //   }
                                      // },
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                height: 20,
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
                                          height: 15,
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
                                                  width: 10,
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
                                          height: 15,
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
                                                  width: 10,
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
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 55,
                              width: 180,
                              child: GestureDetector(
                                onTap: visible
                                    ? () {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            visible = false;
                                          });

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StockDataList(
                                                selectedDateFrom,
                                                selectedDateTo,
                                                constructionId,
                                                selectedConstructionSite,
                                                selectedDealerId,
                                                selectedCategoryId,
                                                selectedItemId,
                                                selectedDealer,
                                                selectedCategory,
                                                selectedItem,
                                              ),
                                            ),
                                          );
                                        } else {
                                          setState(() {
                                            validated = true;
                                          });
                                        }
                                      }
                                    : () {
                                        print('In Process');
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
                                        child: visible
                                            ? Text(
                                                "Search",
                                                style: activeSubTitleStyle,
                                              )
                                            : CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
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

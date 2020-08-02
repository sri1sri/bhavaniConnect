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
  final DateTime startDate;
  final DateTime endDate;
  const GoodsFilter({Key key, this.startDate, this.endDate}) : super(key: key);
  @override
  _GoodsFilter createState() => _GoodsFilter();
}

class _GoodsFilter extends State<GoodsFilter> {
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");

  String constructionId;
  String selectedConstructionSite;

  String selectedDealerId;
  String selectedDealer;

  String selectedConcreteType;
  String selectedConcreteTypeId;

  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final FocusNode _vehicleNumbeFocusNode = FocusNode();

  bool validated = false;

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
      lastDate: DateTime.now(),
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
      lastDate: DateTime.now(),
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
                                              selectedConstructionSite =
                                                  snapshot.data.documents
                                                      .firstWhere((element) =>
                                                          element.documentID ==
                                                          value)['name']
                                                      .toString();
                                              constructionId = value;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      label: "Construction Site",
                                      onChanged: (value) {},
                                      selectedItem: selectedConstructionSite ??
                                          "Choose Construction Site",
                                      showSearchBox: true,
                                      validate: (value) {
                                        if (validated &&
                                            (selectedConstructionSite == null ||
                                                selectedConstructionSite
                                                    .isEmpty)) {
                                          return "Construction Site cannot be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                    );
                                  }
                                },
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
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection(AppConstants.prod + "dealer")
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
                                          "Choose Dealer Name",
                                      showSearchBox: true,
                                      validate: (value) {
                                        if (validated &&
                                            (selectedDealer == null ||
                                                selectedDealer.isEmpty)) {
                                          return "Dealer Name cannot be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                    );
                                  }
                                },
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
                              StreamBuilder(
                                stream: Firestore.instance
                                    .collection(AppConstants.prod + "category")
                                    .orderBy('name', descending: false)
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
                                              selectedConcreteType = snapshot
                                                  .data.documents
                                                  .firstWhere((element) =>
                                                      element.documentID ==
                                                      value)['name']
                                                  .toString();
                                              selectedConcreteTypeId = value;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                      label: "Category Type",
                                      onChanged: (value) {},
                                      selectedItem: selectedConcreteType ??
                                          "Choose Category Type",
                                      showSearchBox: true,
                                      validate: (value) {
                                        if (validated &&
                                            (selectedConcreteType == null ||
                                                selectedConcreteType.isEmpty)) {
                                          return "Category Type cannot be empty";
                                        } else {
                                          return null;
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                              SizedBox(
                                height: getDynamicHeight(20),
                              ),
                              Text(
                                "Vehicle Number ",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: getDynamicHeight(10),
                              ),
                              TextFormField(
                                controller: _vehicleNumberController,
                                //initialValue: _name,
                                textInputAction: TextInputAction.done,
                                obscureText: false,
                                validator: (value) => value.isNotEmpty
                                    ? null
                                    : 'Vehicle Number cant\'t be empty.',
                                focusNode: _vehicleNumbeFocusNode,
                                //onSaved: (value) => _name = value,
                                decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.keyboard,
                                    color: backgroundColor,
                                  ),
                                  labelText: 'Enter Vehicle Number',
                                  //fillColor: Colors.redAccent,
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                ),

                                keyboardType: TextInputType.text,
                                style: new TextStyle(
                                  fontFamily: "Poppins",
                                ),
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
                                                  width: getDynamicWidth(10),
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
                                                  width: getDynamicWidth(10),
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
                          height: getDynamicHeight(30),
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
                                      builder: (context) => PrintPreviewGoods(
                                        selectedDateFrom,
                                        selectedDateTo,
                                        constructionId,
                                        selectedConstructionSite,
                                        selectedDealerId,
                                        selectedDealer,
                                        _vehicleNumberController.text,
                                        selectedConcreteTypeId,
                                        selectedConcreteType,
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
                                        "Search",
                                        style: activeSubTitleStyle,
                                      ))
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

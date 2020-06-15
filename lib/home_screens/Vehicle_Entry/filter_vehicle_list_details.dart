import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Vehicle_Entry/filtered_vehicle_list_details.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleFilter extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const VehicleFilter({Key key, this.startDate, this.endDate})
      : super(key: key);
  @override
  _VehicleFilter createState() => _VehicleFilter();
}

class _VehicleFilter extends State<VehicleFilter> {
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");

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

  String selectedConstructionSite;
  String selectedConstructionId;
  bool validated = false;

  String selectedDealer;
  String selectedDealerId;

  String _SellerName;
  String _SiteName;

  final _formKey = GlobalKey<FormState>();
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
          rightAction: () {},
          primaryText: 'Search Vehicle',
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
                                "Dealer Name",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: 20,
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
                                height: 20,
                              ),
                              Text(
                                "Construction Site",
                                style: titleStyle,
                              ),
                              SizedBox(
                                height: 20,
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
                                              selectedConstructionId = value;
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
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    print(selectedDealerId.runtimeType);
                                    print(selectedConstructionSite);
                                    print(selectedConstructionSite.runtimeType);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VehicleDataList(
                                          selectedDateFrom,
                                          selectedDateTo,
                                          selectedConstructionId,
                                          selectedConstructionSite,
                                          selectedDealerId,
                                          selectedDealer,
                                        ),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      validated = true;
                                    });
                                  }

                                  // Navigator.of(context).pop();

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => VehicleDataList(),
                                  //   ),
                                  // );
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

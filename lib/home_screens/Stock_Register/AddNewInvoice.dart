import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class AddInvoice extends StatefulWidget {
  final String currentUserId;

  const AddInvoice({Key key, this.currentUserId}) : super(key: key);

  @override
  _AddInvoiceState createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateInvoice = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");

  bool validated = false;

  String selectedConstructionSite;
  String selectedConstructionId;

  String selectedItem;
  String selectedItemId;

  String selectedUnits;
  String selectedUnitsId;

  String selectedDealer;
  String selectedDealerId;

  String selectedCategory;
  String selectedCategoryId;

  UserRoles userRole;
  String userRoleValue;

  String userName;

  @override
  void initState() {
    super.initState();
    getUserParams();
  }

  getUserParams() async {
    var prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("userRole");
    String name = prefs.getString("userName");
    setState(() {
      userRole = userRoleValues[role];
      userRoleValue = role;
      userName = name;
    });
  }

  Future<Null> showPickerFrom(BuildContext context) async {
    final DateTime pickedFrom = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1930),
      lastDate: DateTime(2010),
    );
    if (pickedFrom != null) {
      setState(() {
        print(customFormat.format(pickedFrom));
        selectedDate = pickedFrom;
      });
    }
  }

  Future<Null> showPickerTo(BuildContext context) async {
    final DateTime pickedTo = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1930),
      lastDate: DateTime(2010),
    );
    if (pickedTo != null) {
      setState(() {
        print(customFormat.format(pickedTo));
        selectedDateInvoice = pickedTo;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  bool visible = true;

  final TextEditingController _invoiceDateController = TextEditingController();
  final FocusNode _invoiceDateFocusNode = FocusNode();
  final TextEditingController _receivedQuantityController =
      TextEditingController();
  final FocusNode _receivedQuantityFocusNode = FocusNode();
  final TextEditingController _issuedQuantityController =
      TextEditingController();
  final FocusNode _issuedQuantityFocusNode = FocusNode();
  final TextEditingController _balanceQuantityController =
      TextEditingController();
  final FocusNode _balanceQuantityFocusNode = FocusNode();
  final TextEditingController _rateController = TextEditingController();
  final FocusNode _rateFocusNode = FocusNode();
  final TextEditingController _subTotalController = TextEditingController();
  final FocusNode _subTotalFocusNode = FocusNode();
  final TextEditingController _gstAmountController = TextEditingController();
  final FocusNode _gstAmountFocusNode = FocusNode();
  final TextEditingController _totalPriceController = TextEditingController();
  final FocusNode _totalPriceFocusNode = FocusNode();
  final TextEditingController _remarkController = TextEditingController();
  final FocusNode _remarkFocusNode = FocusNode();
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
          primaryText: 'Add Stock',
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
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Purchased Date",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () => showPickerFrom(context),
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    size: 30.0,
                                    color: backgroundColor,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('${customFormat2.format(selectedDate)}',
                                      style: highlightDescription),
                                ],
                              ),
                            ),
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
                                      "Choose Construction Site",
                                  showSearchBox: true,
                                  validate: (value) {
                                    if (validated &&
                                        (selectedConstructionSite == null ||
                                            selectedConstructionSite.isEmpty)) {
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
                          Text(
                            "Item Description",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(AppConstants.prod + "items")
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
                                          selectedItem = snapshot.data.documents
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
                                  label: "Item Description",
                                  onChanged: (value) {},
                                  selectedItem:
                                      selectedItem ?? "Choose Item Description",
                                  showSearchBox: true,
                                  validate: (value) {
                                    if (validated &&
                                        (selectedItem == null ||
                                            selectedItem.isEmpty)) {
                                      return "Item Description cannot be empty";
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
                            "Category",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
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
                                  selectedItem:
                                      selectedCategory ?? "Choose Category",
                                  showSearchBox: true,
                                  validate: (value) {
                                    if (validated &&
                                        (selectedCategory == null ||
                                            selectedCategory.isEmpty)) {
                                      return "Category cannot be empty";
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
                            "Uom",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(AppConstants.prod + "units")
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
                                          selectedUnits = snapshot
                                              .data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString();
                                          selectedUnitsId = value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  label: "UOM",
                                  onChanged: (value) {},
                                  selectedItem: selectedUnits ?? "Choose UOM",
                                  showSearchBox: true,
                                  validate: (value) {
                                    if (validated &&
                                        (selectedUnits == null ||
                                            selectedUnits.isEmpty)) {
                                      return "UOM cannot be empty";
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
                            "Dealer Name",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
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
                                  selectedItem:
                                      selectedDealer ?? "Choose Dealer Name",
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
                            "Invoice No.",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _invoiceDateController,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Invoice No. Quantity cant\'t be empty.',
                            focusNode: _invoiceDateFocusNode,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.blur_linear,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Invoice No.',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Received Quantity",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _receivedQuantityController,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Received Quantity cant\'t be empty.',
                            focusNode: _receivedQuantityFocusNode,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.add_shopping_cart,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Received Quantity',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Issued Quantity",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _issuedQuantityController,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Issued Quantity cant\'t be empty.',
                            focusNode: _issuedQuantityFocusNode,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.shopping_cart,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Issued Quantity',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Balance Quantity",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _balanceQuantityController,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Balance Quantity cant\'t be empty.',
                            focusNode: _balanceQuantityFocusNode,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.shopping_basket,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Balance Quantity',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Rate",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _rateController,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Rate cant\'t be empty.',
                            focusNode: _rateFocusNode,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.monetization_on,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Item Rate',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Sub Total",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _subTotalController,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Sub Total cant\'t be empty.',
                            focusNode: _subTotalFocusNode,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Sub Total',
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "GST Amount",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _gstAmountController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'GST Amount cant\'t be empty.',
                            focusNode: _gstAmountFocusNode,
                            //onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.euro_symbol,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter GST Amount',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Total Amount (Including GST)",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _totalPriceController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Total Amount (Including GST) cant\'t be empty.',
                            focusNode: _totalPriceFocusNode,
                            // onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.dashboard,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Total Amount',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Remarks",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _remarkController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Remarks cant\'t be empty.',
                            focusNode: _remarkFocusNode,
                            //onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.list,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Remarks',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 55,
                          width: 180,
                          child: GestureDetector(
                            onTap: visible
                                ? () async {
                                    if (_formKey.currentState.validate() &&
                                        selectedDealer != null &&
                                        selectedCategory != null &&
                                        selectedConstructionSite != null &&
                                        selectedUnits != null &&
                                        selectedItem != null) {
                                      _formKey.currentState.save();
                                      setState(() {
                                        visible = false;
                                      });

                                      String documentId =
                                          "${DateTime.now().millisecondsSinceEpoch}-${widget.currentUserId[5]}";
                                      try {
                                        await Firestore.instance
                                            .collection(AppConstants.prod +
                                                'stockRegister')
                                            .document(documentId)
                                            .setData({
                                          'created_by': {
                                            "id": widget.currentUserId,
                                            "name": userName,
                                            "role": userRoleValue,
                                          },
                                          'documentId': documentId,
                                          'construction_site': {
                                            "constructionId":
                                                selectedConstructionId,
                                            "constructionSite":
                                                selectedConstructionSite,
                                          },
                                          'item': {
                                            "itemId": selectedItemId,
                                            "itemName": selectedItem,
                                          },
                                          'category': {
                                            "categoryId": selectedCategoryId,
                                            "categoryName": selectedCategory,
                                          },
                                          'unit': {
                                            "unitId": selectedUnitsId,
                                            "unitName": selectedUnits,
                                          },
                                          'dealer': {
                                            "dealerId": selectedDealerId,
                                            "dealerName": selectedDealer,
                                          },
                                          'invoice_no':
                                              _invoiceDateController.text,
                                          "received_quantity":
                                              _receivedQuantityController.text,
                                          "issued_quantity":
                                              _issuedQuantityController.text,
                                          'balance_quantity':
                                              _balanceQuantityController.text,
                                          'rate': _rateController.text,
                                          'sub_total': _subTotalController.text,
                                          'gst_amount':
                                              _gstAmountController.text,
                                          'total_amount_gst':
                                              _totalPriceController.text,
                                          'remarks': _remarkController.text,
                                          "added_on":
                                              FieldValue.serverTimestamp(),
                                          "purchase_date": selectedDate,
                                        });
                                        Navigator.pop(context);
                                      } catch (err) {
                                        setState(() {
                                          // isProcessing = false;
                                          // error = err;
                                        });
                                      } finally {
                                        if (mounted) {
                                          setState(() {
                                            // isProcessing = false;
                                          });
                                        }
                                      }
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
                                            "Create",
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
                      height: 50,
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

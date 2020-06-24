import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
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

class AddConcreteEntry extends StatefulWidget {
  final String currentUserId;

  const AddConcreteEntry({Key key, this.currentUserId}) : super(key: key);

  @override
  _AddConcreteEntry createState() => _AddConcreteEntry();
}

class _AddConcreteEntry extends State<AddConcreteEntry> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateInvoice = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");

  final _formKey = GlobalKey<FormState>();
  bool visible = true;

  final TextEditingController _remarkController = TextEditingController();
  final FocusNode _remarkFocusNode = FocusNode();

  bool validated = false;

  String selectedConstructionSite;
  String selectedConstructionId;

  String selectedBlock;
  String selectedBlockId;

  String selectedConcreteType;
  String selectedConcreteTypeId;

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
      lastDate: DateTime.now(),
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
      lastDate: DateTime.now(),
    );
    if (pickedTo != null) {
      setState(() {
        print(customFormat.format(pickedTo));
        selectedDateInvoice = pickedTo;
      });
    }
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
            width: getDynamicWidth(20),
          ),
          rightAction: () {
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Add Entry',
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
                            "Date",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
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
                                    width: getDynamicWidth(10),
                                  ),
                                  Text('${customFormat2.format(selectedDate)}',
                                      style: highlightDescription),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
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
                            selectedItem: selectedBlock ?? "Choose Block",
                            showSearchBox: true,
                            validate: (value) {
                              if (validated &&
                                  (selectedBlock == null ||
                                      selectedBlock.isEmpty)) {
                                return "Block cannot be empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Concrete Type",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          DropdownSearch(
                            showSelectedItem: true,
                            maxHeight: 400,
                            mode: Mode.MENU,
                            items: AppConstants.concreteType,
                            dropdownItemBuilder: (context, value, isTrue) {
                              return ListTile(
                                title: Text(value),
                                selected: isTrue,
                                onTap: () {
                                  setState(() {
                                    selectedConcreteType = value;
                                    selectedConcreteTypeId = value;
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                            label: "Concrete Type",
                            onChanged: (value) {},
                            selectedItem:
                                selectedConcreteType ?? "Choose Concrete Type",
                            showSearchBox: true,
                            validate: (value) {
                              if (validated &&
                                  (selectedConcreteType == null ||
                                      selectedConcreteType.isEmpty)) {
                                return "Concrete Type cannot be empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Remarks",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
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
                            height: getDynamicHeight(20),
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
                            onTap: visible
                                ? () async {
                                    if (_formKey.currentState.validate() &&
                                        selectedConcreteType != null &&
                                        selectedConstructionSite != null &&
                                        selectedBlock != null) {
                                      _formKey.currentState.save();
                                      setState(() {
                                        visible = false;
                                      });

                                      String documentId =
                                          "${DateTime.now().millisecondsSinceEpoch}-${widget.currentUserId[5]}";
                                      try {
                                        await Firestore.instance
                                            .collection(AppConstants.prod +
                                                'concreteEntries')
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
                                          'block': {
                                            "blockId": selectedBlockId,
                                            "blockName": selectedBlock,
                                          },
                                          'concrete_type': {
                                            "concreteTypeId":
                                                selectedConcreteTypeId,
                                            "concreteTypeName":
                                                selectedConcreteType,
                                          },
                                          'total_progress': "0",
                                          'remark': _remarkController.text,
                                          "added_on":
                                              FieldValue.serverTimestamp(),
                                          "selected_date": selectedDate,
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
                      height: getDynamicHeight(50),
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

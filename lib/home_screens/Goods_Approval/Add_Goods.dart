import 'dart:async';

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class AddGoods extends StatefulWidget {
  final String currentUserId;

  const AddGoods({Key key, this.currentUserId}) : super(key: key);
  @override
  _AddGoods createState() => _AddGoods();
}

class _AddGoods extends State<AddGoods> {
  bool visible = true;
  final _formKey = GlobalKey<FormState>();
  String selectedConstructionSite;
  String selectedConstructionId;
  bool validated = false;

  String selectedConcreteType;
  String selectedConcreteTypeId;
  String selectedDealer;
  String selectedDealerId;
  UserRoles userRole;
  String userRoleValue;

  String userName;
  List<String> permissionDocId = [];
  List<String> permissionDocUserName = [];
  List<String> permissionDocUserRole = [];
  final TextEditingController _vehicleNumberController =
  TextEditingController();
  final FocusNode _vehicleNumbeFocusNode = FocusNode();
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

  permissionSetData(
      String vehicleDocumentId, constructionSite, constructionId) async {
    List permissionBy = [];
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection(AppConstants.prod + "userData")
        .where("construction_site.constructionId", isEqualTo: constructionId)
        .where("role",
            whereIn: ["Supervisor", "Store Manager", "Manager"]).getDocuments();
    var list = querySnapshot.documents;
    for (int i = 0; i < list.length; i++) {
      permissionDocId.add(list[i].documentID);
      permissionBy.add({
        "userId": list[i].documentID,
        'userName': list[i].data['name'],
        "role": list[i].data['role'],
        "token": list[i].data['token'],
      });
    }

    await Firestore.instance
        .collection(AppConstants.prod + 'pendingRequests')
        .document(vehicleDocumentId)
        .setData({
      'collectionDocId': vehicleDocumentId,
      'created_by': {
        "id": widget.currentUserId,
        "name": userName,
        "role": userRoleValue,
      },
      'permissions': permissionDocId,
      'permission_by': permissionBy,
      "added_on": FieldValue.serverTimestamp(),
      'collectionName': AppConstants.prod + "goodsApproval"
    });
    Navigator.of(context).pop();
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
            width: 10,
          ),
          rightAction: () {
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Add Goods',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          height: double.infinity,
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
                          // DropdownSearch(
                          //     showSelectedItem: true,
                          //     maxHeight: 400,
                          //     mode: Mode.MENU,
                          //     items: [
                          //       "Bhavani Vivan",
                          //       "Bhavani Aravindam",
                          //       "Bhavani Vivan",
                          //       "Bhavani Aravindam",
                          //     ],
                          //     label: "Construction Site",
                          //     onChanged: print,
                          //     selectedItem: "Choose Construction Site",
                          //     showSearchBox: true),
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
                            "Category",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
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
                            "Dealer Name",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
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
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
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
                                        selectedDealer != null) {
                                      _formKey.currentState.save();
                                      setState(() {
                                        visible = false;
                                      });
                                      String documentId =
                                          "${DateTime.now().millisecondsSinceEpoch}-${widget.currentUserId[5]}";
                                      try {
                                        await Firestore.instance
                                            .collection(AppConstants.prod +
                                                'goodsApproval')
                                            .document(documentId)
                                            .setData({
                                          'created_by': {
                                            "id": widget.currentUserId,
                                            "name": userName,
                                            "role": userRoleValue,
                                          },
                                          'documentId': documentId,
                                          'approved_by': userRole !=
                                                  UserRoles.Securtiy
                                              ? {
                                                  "id": widget.currentUserId,
                                                  "name": userName,
                                                  "role": userRoleValue,
                                                  'at': FieldValue
                                                      .serverTimestamp(),
                                                }
                                              : {
                                                  "id": '',
                                                  "name": '',
                                                  "role": '',
                                                  'at': FieldValue
                                                      .serverTimestamp(),
                                                },
                                          'construction_site': {
                                            "constructionId":
                                                selectedConstructionId,
                                            "constructionSite":
                                                selectedConstructionSite,
                                          },
                                          'concrete_type': {
                                            "concreteTypeId":
                                                selectedConcreteTypeId,
                                            "concreteTypeName":
                                                selectedConcreteType,
                                          },
                                          'dealer': {
                                            "dealerId": selectedDealerId,
                                            "dealerName": selectedDealer,
                                          },
                                          "added_on":
                                              FieldValue.serverTimestamp(),
                                          "status":
                                              userRole == UserRoles.Securtiy
                                                  ? "Pending"
                                                  : "Approved",
                                        });

                                        if (userRole == UserRoles.Securtiy) {
                                          permissionSetData(
                                            documentId,
                                            selectedConstructionSite,
                                            selectedConstructionId,
                                          );
                                        } else {
                                          Navigator.pop(context);
                                        }
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

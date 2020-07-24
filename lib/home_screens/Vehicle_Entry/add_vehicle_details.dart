import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class AddVehicle extends StatefulWidget {
  final String currentUserId;

  const AddVehicle({Key key, this.currentUserId}) : super(key: key);
  @override
  _AddVehicle createState() => _AddVehicle();
}

class _AddVehicle extends State<AddVehicle> {
  final _formKey = GlobalKey<FormState>();
  bool visible = true;
  String _myActivity;
  String _myActivityResult;
  FocusNode focusNode = FocusNode();
  final TextEditingController _vehicleNameController = TextEditingController();
  final FocusNode _vehicleNameFocusNode = FocusNode();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final FocusNode _vehicleNumbeFocusNode = FocusNode();
  final TextEditingController _unitController = TextEditingController();
  final FocusNode _unitFocusNode = FocusNode();
  List dataSource = [
    {
      "display": "Running",
      "value": "Running",
    },
    {
      "display": "Climbing",
      "value": "Climbing",
    },
    {
      "display": "Walking",
      "value": "Walking",
    },
    {
      "display": "Swimming",
      "value": "Swimming",
    },
    {
      "display": "Soccer Practice",
      "value": "Soccer Practice",
    },
    {
      "display": "Baseball Practice",
      "value": "Baseball Practice",
    },
    {
      "display": "Football Practice",
      "value": "Football Practice",
    },
  ];
  // int _key;
  // _collapse() {
  //   int newKey;
  //   do {
  //     _key = new Random().nextInt(10000);
  //   } while (newKey == _key);
  // }

  String vehicleCategory = '';
  String vehicleCategoryId;

  String selectedConstructionSite;
  String selectedConstructionId;
  bool validated = false;

  String selectedDealer;
  String selectedDealerId;

  String _selectedUnitId;
  String _selectedUnit;
  String _selectedVehicleType = '';

  UserRoles userRole;
  String userRoleValue;
  String userName;
  // String userConstructionSiteId;
  // String userConstructionSite;
  List<String> permissionDocId = [];
  List<String> permissionDocUserName = [];
  List<String> permissionDocUserRole = [];

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
    focusNode.addListener(() {
      focusNode.unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
      //      focusNode.
    });
    getUserParams();
  }

  getUserParams() async {
    var prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("userRole");
    String name = prefs.getString("userName");
    // userConstructionSiteId = prefs.getString("userConstSiteId");
    // userConstructionSite = prefs.getString("userConstSite");
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
      print('asd');
      permissionDocId.add(list[i].documentID);
      permissionBy.add({
        "userId": list[i].documentID,
        'userName': list[i].data['name'],
        "role": list[i].data['role'],
        "token": list[i].data['token'],
      });
    }

    // print(permissionDocId.length);
    // print("-------------$permissionDocId---------------");
    // print("-------------$permissionDocUserName---------------");
    // print("-------------$permissionDocUserRole---------------");

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
      'collectionName': AppConstants.prod + "vehicleEntries"
    });
    Navigator.of(context).pop();
  }

  var category = [
    "Jcb/Hitachi",
    "Tractor",
    "Road Roller",
    "Cement Mixer",
    "Excavator",
    "BoreWell",
    "Pickup Truck",
    "GoodsTruck",
    "Driller",
    "Crane",
    "Fork Lift",
    "Others"
  ];
  List<String> F_image = [
    "images/jcb.png",
    "images/c1.png",
    "images/c9.png",
    "images/c3.png",
    "images/c4.png",
    "images/c5.png",
    "images/c6.png",
    "images/c7.png",
    "images/c8.png",
    "images/c10.png",
    "images/inventory.png",
    "images/c11.png",
  ];

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
            padding: EdgeInsets.only(top: 10),
            child: InkWell(
                child: Icon(
                  Icons.more_vert,
                  color: backgroundColor,
                  size: 30,
                ),
                onTap: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => SettingsPage() ),
//                  );
                }),
          ),
          rightAction: () {
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Add vehicle',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: getDynamicHeight(30),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Text(
                  //     "Vehicle category",
                  //     style: titleStyle,
                  //   ),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Color(0xffBFBFBF), width: 1),
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(5),
                  //     ),
                  //   ),
                  //   margin: EdgeInsets.only(left: 10, right: 10),
                  //   child: ExpansionTile(
                  //       key: new Key(_key.toString()),
                  //       title: Text(
                  //         vehicleCategory != ""
                  //             ? vehicleCategory
                  //             : "Choose the Vehicle",
                  //         style: descriptionStyleDarkBlur1,
                  //       ),
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.all(10.0),
                  //           child: Container(
                  //             height: 420,
                  //             child: Expanded(
                  //               child: GridView.builder(
                  //                 itemCount: category.length,
                  //                 gridDelegate:
                  //                     new SliverGridDelegateWithFixedCrossAxisCount(
                  //                         crossAxisCount: 3,
                  //                         mainAxisSpacing: 5,
                  //                         crossAxisSpacing: 10),
                  //                 itemBuilder:
                  //                     (BuildContext context, int index) {
                  //                   return new GestureDetector(
                  //                     child: new Card(
                  //                       elevation: 10.0,
                  //                       child: new Container(
                  //                         alignment: Alignment.center,
                  //                         margin: new EdgeInsets.only(
                  //                             top: 5.0,
                  //                             bottom: 0.0,
                  //                             left: 0.0,
                  //                             right: 0.0),
                  //                         child: new Column(
                  //                           children: <Widget>[
                  //                             Image.asset(
                  //                               F_image[index],
                  //                               height: 70,
                  //                             ),
                  //                             SizedBox(
                  //                               height: 5,
                  //                             ),
                  //                             new Text(
                  //                               category[index],
                  //                               style: descriptionStyle,
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     onTap: () {
                  //                       setState(() {
                  //                         vehicleCategory =
                  //                             category[index].toString();
                  //                         vehicleCategoryId = "$index";
                  //                         _collapse();
                  //                       });
                  //                       // switch (category[index]) {
                  //                       //   case 'Jcb/Hitachi':
                  //                       //     {
                  //                       //       print("case 1 is selected");
                  //                       //     }
                  //                       //     break;

                  //                       //   case 'Tractor':
                  //                       //     {
                  //                       //       print("case 2 is selected");
                  //                       //     }
                  //                       //     break;
                  //                       //   case 'Road Roller':
                  //                       //     {
                  //                       //       print("case 3 is selected");
                  //                       //     }
                  //                       //     break;

                  //                       //   case 'Cement Mixer':
                  //                       //     {
                  //                       //       print("case 4 is selected");
                  //                       //     }
                  //                       //     break;

                  //                       //   case 'Excavator':
                  //                       //     {
                  //                       //       print("case 5 is selected");
                  //                       //     }
                  //                       //     break;
                  //                       //   case 'BoreWell':
                  //                       //     {
                  //                       //       print("case 6 is selected");
                  //                       //     }
                  //                       //     break;
                  //                       //   case 'Pickup Truck':
                  //                       //     {
                  //                       //       print("case 7 is selected");
                  //                       //     }
                  //                       //     break;
                  //                       //   case 'GoodsTruck':
                  //                       //     {
                  //                       //       print("case 8 is selected");
                  //                       //     }
                  //                       //     break;
                  //                       //   case 'Driller':
                  //                       //     {
                  //                       //       print("case 9 is selected");
                  //                       //     }
                  //                       //     break;
                  //                       //   case 'Crane':
                  //                       //     {
                  //                       //       print("case 10 is selected");
                  //                       //     }
                  //                       //     break;

                  //                       //   case 'Fork Lift':
                  //                       //     {
                  //                       //       print("case 11 is selected");
                  //                       //     }
                  //                       //     break;
                  //                       //   case 'Others':
                  //                       //     {
                  //                       //       print("case 12 is selected");
                  //                       //     }
                  //                       //     break;

                  //                       //   default:
                  //                       //     {}
                  //                       //     break;

                  //                       // }
                  //                     },
                  //                   );
                  //                 },
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ]),
                  // ),
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
                          height: getDynamicHeight(10),
                        ),
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection(
                                  AppConstants.prod + "constructionSite")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              List<String> items = snapshot.data.documents
                                  .map((e) => (e.documentID.toString()))
                                  .toList();
                              return DropdownSearch(
                                showSelectedItem: true,
                                maxHeight: 400,
                                mode: Mode.MENU,
                                items: items,
                                dropdownItemBuilder: (context, value, isTrue) {
                                  return ListTile(
                                    title: Text(snapshot.data.documents
                                        .firstWhere((element) =>
                                            element.documentID == value)['name']
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
                          "Dealer Name",
                          style: titleStyle,
                        ),
                        SizedBox(
                          height: getDynamicHeight(10),
                        ),
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection(AppConstants.prod + "dealer")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              List<String> items = snapshot.data.documents
                                  .map((e) => (e.documentID.toString()))
                                  .toList();
                              return DropdownSearch(
                                showSelectedItem: true,
                                maxHeight: 400,
                                mode: Mode.MENU,
                                items: items,
                                dropdownItemBuilder: (context, value, isTrue) {
                                  return ListTile(
                                    title: Text(snapshot.data.documents
                                        .firstWhere((element) =>
                                            element.documentID == value)['name']
                                        .toString()),
                                    selected: isTrue,
                                    onTap: () {
                                      setState(() {
                                        selectedDealer = snapshot.data.documents
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
                              : 'vehicle Number cant\'t be empty.',
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
                        SizedBox(
                          height: getDynamicHeight(20),
                        ),
                        Text(
                          "Units per Trip",
                          style: titleStyle,
                        ),
                        SizedBox(
                          height: getDynamicHeight(10),
                        ),
                        TextFormField(
                          controller: _unitController,
                          //initialValue: _name,
                          textInputAction: TextInputAction.done,
                          obscureText: false,
                          validator: (value) => value.isNotEmpty
                              ? null
                              : 'company name cant\'t be empty.',
                          focusNode: _unitFocusNode,
                          //onSaved: (value) => _name = value,
                          decoration: new InputDecoration(
                            prefixIcon: Icon(
                              Icons.keyboard,
                              color: backgroundColor,
                            ),
                            labelText: 'Enter Units per Trip',
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
                          height: getDynamicHeight(20),
                        ),
                        Text(
                          "Units",
                          style: titleStyle,
                        ),
                        SizedBox(
                          height: getDynamicHeight(10),
                        ),
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection(AppConstants.prod + "units")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              List<String> items = snapshot.data.documents
                                  .map((e) => (e.documentID.toString()))
                                  .toList();
                              return DropdownSearch(
                                showSelectedItem: true,
                                maxHeight: 400,
                                mode: Mode.MENU,
                                items: items,
                                dropdownItemBuilder: (context, value, isTrue) {
                                  return ListTile(
                                    title: Text(snapshot.data.documents
                                        .firstWhere((element) =>
                                            element.documentID == value)['name']
                                        .toString()),
                                    selected: isTrue,
                                    onTap: () {
                                      setState(() {
                                        _selectedUnit = snapshot.data.documents
                                            .firstWhere((element) =>
                                                element.documentID ==
                                                value)['name']
                                            .toString();
                                        _selectedUnitId = value;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                                label: "Units",
                                onChanged: (value) {},
                                selectedItem: _selectedUnit ?? "Choose Units",
                                showSearchBox: true,
                                validate: (value) {
                                  if (validated &&
                                      (_selectedUnit == null ||
                                          _selectedUnit.isEmpty)) {
                                    return "Units cannot be empty";
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
                          "Vehicle Type",
                          style: titleStyle,
                        ),
                        SizedBox(
                          height: getDynamicHeight(10),
                        ),
                        DropdownSearch(
                          showSelectedItem: true,
                          maxHeight: 200,
                          mode: Mode.MENU,
                          items: [
                            "Trips",
                            "Readings",
                          ],
                          label: "Vehicle Type",
                          // onChanged: print,
                          // selectedItem: "Choose Vehicle Type",
                          showSearchBox: true,
                          onChanged: (value) {
                            setState(() {
                              _selectedVehicleType = value;
                            });
                          },
                          selectedItem: _selectedVehicleType != ""
                              ? _selectedVehicleType
                              : "Choose Vehicle Type",
                          validate: (value) => value == null
                              ? 'Vehicle Type cannot be empty'
                              : null,
                        ),
                        SizedBox(
                          height: getDynamicHeight(20),
                        ),
                        Text(
                          "Vehicle Name ",
                          style: titleStyle,
                        ),
                        SizedBox(
                          height: getDynamicHeight(10),
                        ),
                        DropdownSearch(
                          showSelectedItem: true,
                          maxHeight: 400,
                          mode: Mode.MENU,
                          items: [
                            "Tractor",
                            "JcB",
                            "Cement Mixer",
                            "Goods Truck"
                          ],
                          label: "Vehicle Name",
                          onChanged: print,
                          selectedItem: "Choose Vehicle Name",
                          showSearchBox: true,
//                          onChanged: (value) {
//                            setState(() {
//                              _selectedVehicleType = value;
//                            });
//                          },
//                          selectedItem: _selectedVehicleType != ""
//                              ? _selectedVehicleType
//                              : "Choose Vehicle Name",
//                          validate: (value) => value == null
//                              ? 'Vehicle Name cannot be empty'
//                              : null,
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
                        width: getDynamicHeight(180),
                        child: GestureDetector(
                          onTap: visible
                              ? () async {
                                  if (_formKey.currentState.validate() &&
                                      selectedConstructionSite != null &&
                                      vehicleCategory != null &&
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
                                              'vehicleEntries')
                                          .document(documentId)
                                          .setData({
                                        'created_by': {
                                          "id": widget.currentUserId,
                                          "name": userName,
                                          "role": userRoleValue,
                                          'at': FieldValue.serverTimestamp(),
                                        },
                                        'approved_by':
                                            userRole != UserRoles.Securtiy
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
                                        'documentId': documentId,
                                        'construction_site': {
                                          "constructionId":
                                              selectedConstructionId,
                                          "constructionSite":
                                              selectedConstructionSite,
                                        },
                                        'dealer': {
                                          "dealerId": selectedDealerId,
                                          "dealerName": selectedDealer,
                                        },
                                        "vehicleNumber":
                                            _vehicleNumberController.text,
                                        "unitsPerTrip": _unitController.text,
                                        "units": {
                                          "unitId": _selectedUnitId,
                                          "unitName": _selectedUnit,
                                        },
                                        "vehicleType": _selectedVehicleType,
                                        "added_on":
                                            FieldValue.serverTimestamp(),
                                        "status": userRole == UserRoles.Securtiy
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
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
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
                    height: 400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

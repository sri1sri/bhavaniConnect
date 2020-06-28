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

class IssuedDetails extends StatefulWidget {
  final String constructionId;
  final String stockId;
  final String currentUserId;

  const IssuedDetails(
      {Key key, this.constructionId, this.stockId, this.currentUserId})
      : super(key: key);

  @override
  _IssuedDetails createState() => _IssuedDetails();
}

class _IssuedDetails extends State<IssuedDetails> {
  final _formKey = GlobalKey<FormState>();
  bool visible = true;

  final TextEditingController _issuedQuantityController =
      TextEditingController();
  final FocusNode _issuedQuantityFocusNode = FocusNode();
  UserRoles userRole;
  String userRoleValue;

  String siteId;

  String userName;

  String selectedUser;
  String selectedUserRole;
  String selectedUserId;

  bool validated = false;

  @override
  void initState() {
    super.initState();
    getUserParams();
  }

  getUserParams() async {
    var prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("userRole");
    String name = prefs.getString("userName");
    String constructionSiteId = prefs.getString("constructionId");
    setState(() {
      userRole = userRoleValues[role];
      userRoleValue = role;
      userName = name;
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
          primaryText: 'Add Issue Details',
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
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Issued Quantity",
                            style: titleStyle,
                          ),
                          SizedBox(height: getDynamicHeight(20)),
                          TextFormField(
                            controller: _issuedQuantityController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Issued Quantity cant\'t be empty.',
                            focusNode: _issuedQuantityFocusNode,
                            // onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.data_usage,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Issued Quantity',
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
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Issued To",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(AppConstants.prod + "userData")
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
                                              .toString() +
                                          " (" +
                                          snapshot.data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['role']
                                              .toString() +
                                          ")"),
                                      selected: isTrue,
                                      onTap: () {
                                        setState(() {
                                          selectedUser = snapshot.data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString();

                                          selectedUserRole = snapshot
                                              .data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['role']
                                              .toString();
                                          selectedUserId = value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  label: "Choose Issued To",
                                  onChanged: (value) {},
                                  selectedItem: selectedUser != null
                                      ? selectedUser.toString() +
                                          " (" +
                                          selectedUserRole.toString() +
                                          ")"
                                      : "Choose Issued To",
                                  showSearchBox: true,
                                  validate: (value) {
                                    if (validated &&
                                        (selectedUserId == null ||
                                            selectedUserId.isEmpty)) {
                                      return 'Issued To cant\'t be empty.';
                                    } else {
                                      return null;
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(height: getDynamicHeight(20)),
                        ],
                      ),
                    ),
                    SizedBox(height: getDynamicHeight(20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: getDynamicHeight(55),
                          width: getDynamicWidth(180),
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState.validate() &&
                                  selectedUser != null) {
                                _formKey.currentState.save();
                                setState(() {
                                  visible = false;
                                });

                                String documentId =
                                    "${DateTime.now().millisecondsSinceEpoch}-${widget.currentUserId[5]}";
                                try {
                                  await Firestore.instance
                                      .collection(
                                          AppConstants.prod + 'stockIssued')
                                      .document(documentId)
                                      .setData({
                                    'created_by': {
                                      "id": widget.currentUserId,
                                      "name": userName,
                                      "role": userRoleValue,
                                    },
                                    'documentId': documentId,
                                    'construction_site': {
                                      "constructionId": widget.constructionId,
                                    },
                                    'stockId': widget.stockId,
                                    'issuedQuantity':
                                        _issuedQuantityController.text,
                                    'issued_to': {
                                      "id": selectedUserId,
                                      "name": selectedUser,
                                      "role": selectedUserRole,
                                    },
                                    "added_on": FieldValue.serverTimestamp(),
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
                                            "Add Details",
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

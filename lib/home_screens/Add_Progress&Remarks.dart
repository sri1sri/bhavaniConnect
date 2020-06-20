import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhavaniconnect/common_variables/app_constants.dart';

class AddProgressRemarks extends StatefulWidget {
  final String currentUserId;
  final String documentId;
  final String tableName;

  const AddProgressRemarks(
      {Key key, this.currentUserId, this.documentId, this.tableName})
      : super(key: key);

  @override
  _AddProgressRemarks createState() => _AddProgressRemarks();
}

class _AddProgressRemarks extends State<AddProgressRemarks> {
  final _formKey = GlobalKey<FormState>();
  bool visible = true;

  final TextEditingController _yesterdayProgressController =
      TextEditingController();
  final FocusNode _yesterdayProgressFocusNode = FocusNode();
  final TextEditingController _remarkController = TextEditingController();
  final FocusNode _remarkFocusNode = FocusNode();

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
          primaryText: 'Add Progress',
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
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Yesterday's Progress",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _yesterdayProgressController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty
                                ? null
                                : 'Yesterdays Progress cant\'t be empty.',
                            focusNode: _yesterdayProgressFocusNode,
                            // onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.data_usage,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Yesterdays Progress',
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
                                ? () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      setState(() {
                                        visible = false;
                                      });
                                      String documentId = DateTimeUtils
                                          .currentDayDateTimeNow
                                          .millisecondsSinceEpoch
                                          .toString();
                                      int totalProgress = 0;
                                      try {
                                        Firestore.instance
                                            .collection(AppConstants.prod +
                                                'activityProgress/${widget.documentId}/${widget.documentId}')
                                            .document(documentId)
                                            .setData({
                                          'created_by': {
                                            "id": widget.currentUserId,
                                            "name": userName,
                                            "role": userRoleValue,
                                          },
                                          'documentId': documentId,
                                          'yesterday_progress':
                                              _yesterdayProgressController.text,
                                          'remark': _remarkController.text,
                                          "added_on":
                                              FieldValue.serverTimestamp(),
                                        }).then((value) async {
                                          QuerySnapshot result = await Firestore
                                              .instance
                                              .collection(AppConstants.prod +
                                                  'activityProgress/${widget.documentId}/${widget.documentId}')
                                              .getDocuments();

                                          if (result != null &&
                                              result.documents != null) {
                                            for (int i = 0;
                                                i < result.documents.length;
                                                i++) {
                                              totalProgress = totalProgress +
                                                  int.parse(result.documents[i]
                                                      ['yesterday_progress']);
                                            }

                                            Firestore.instance
                                                .collection(widget.tableName)
                                                .document(widget.documentId)
                                                .updateData({
                                              'total_progress':
                                                  totalProgress.toString()
                                            });
                                            Navigator.pop(context);
                                          }
                                        });
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
                                            "Add Progress",
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
          ),
        ),
      ),
    );
  }
}

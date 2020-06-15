import 'dart:io';
import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/button_widget/to_do_button.dart';
import 'package:bhavaniconnect/common_widgets/image_widget/avatar_selector.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/models/current-area.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  final FirebaseUser user;

  const SignUpPage({Key key, this.user}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int group = 1;
  File _profilePic;
  DateTime selectedDate;
  DateTime initialDate = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMMM yyyy");

  String selectedRole;
  String selectedConstructionSite;
  String selectedConstructionId;
  double selectedConstructionLat;
  double selectedConstructionLong;

  bool validated = false;

  final _formKey = GlobalKey<FormState>();

  LatLng currentLocation;

//  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://bconnect-9d1b5.appspot.com/');
//  StorageUploadTask _uploadTask;
  String _profilePicPathURL;

  bool _loading;
  double _progressValue;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _loading = false;
    _progressValue = 0.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    await CurrentArea.instance.getCurrentLocation().then((location) async {
      if (location != null) {
        currentLocation = LatLng(location.latitude, location.longitude);
        var prefs = await SharedPreferences.getInstance();
        prefs.setDouble("latitude", currentLocation.latitude);
        prefs.setDouble("longitude", currentLocation.longitude);
      }
    });
  }

  Future<Null> showPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        print(customFormat.format(picked));
        selectedDate = picked;
      });
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();

  //SignUpModel get model => widget.model;

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Scaffold(
          body: SingleChildScrollView(child: _buildContent(context)),
        ),
      ),
    );
  }

//  Future<void> _captureImage() async{
//    File profileImage = await ImagePicker.pickImage(source: IMAGE_SOURCE);
//setState(() {
//  _profilePic = profileImage;
//  print(_profilePic);
//});
//  }

  Widget _buildContent(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Create your own \naccount today',
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'To create an Account enter your name and date of birth.',
                    style: descriptionStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    AvatarSelector(widget.user.uid, true),
                    SizedBox(height: 20.0),
                    new TextFormField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.done,
                      obscureText: false,
                      focusNode: _usernameFocusNode,
                      // onEditingComplete: () => _imageUpload(),
                      // onChanged: model.updateUsername,
                      decoration: new InputDecoration(
//                      prefixIcon: Icon(
//                        Icons.account_circle,
//                        color: backgroundColor,
//                      ),
                        labelText: "Enter your name",
                        labelStyle: descriptionStyleDark,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Username cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    StreamBuilder(
                      stream: Firestore.instance.collection("role").snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          List<String> items = snapshot.data.documents
                              .map((e) => (e['name'].toString()))
                              .toList();
                          return DropdownSearch(
                            showSelectedItem: true,
                            maxHeight: 400,
                            mode: Mode.MENU,
                            items: items,
                            label: "Employee Role",
                            onChanged: (String value) {
                              setState(() {
                                selectedRole = value;
                              });
                            },
                            selectedItem: selectedRole ?? "Choose your role",
                            showSearchBox: true,
                            validate: (value) {
                              if (validated &&
                                  (selectedRole == null ||
                                      selectedRole.isEmpty)) {
                                return "Employee Role cannot be empty";
                              } else {
                                return null;
                              }
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    StreamBuilder(
                      stream: Firestore.instance
                          .collection("constructionSite")
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
                                            element.documentID == value)['name']
                                        .toString();

                                    GeoPoint geoPoint = snapshot.data.documents
                                        .firstWhere((element) =>
                                            element.documentID ==
                                            value)['location'];
                                    if (geoPoint != null) {
                                      selectedConstructionLat =
                                          geoPoint.latitude;
                                      selectedConstructionLong =
                                          geoPoint.longitude;
                                    }
                                    selectedConstructionSite = snapshot
                                        .data.documents
                                        .firstWhere((element) =>
                                            element.documentID == value)['name']
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
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, bottom: 10),
                      child: Container(
                        child: RaisedButton(
                          color: Colors.white,
                          child: Container(
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  'Select your date of birth.',
                                  style: descriptionStyle,
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
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
                                              '${customFormat2.format(selectedDate ?? initialDate)}',
                                              style: subTitleStyle),
                                        ],
                                      ),
                                    ),
                                    Text('Change', style: subTitleStyle),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          onPressed: () => showPicker(context),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: validated && selectedDate == null,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text(
                          "Please Select your date of birth.",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Gender",
                          style: subTitleStyle1,
                        ),
                        Radio(
                          value: 1,
                          groupValue: group,
                          onChanged: (T) {
                            print(T);
                            setState(() {
                              group = T;
                            });
                          },
                        ),
                        Text(
                          "Male",
                          style: descriptionStyleDarkBlur2,
                        ),
                        Radio(
                          value: 2,
                          groupValue: group,
                          onChanged: (T) {
                            print(T);
                            setState(() {
                              group = T;
                            });
                          },
                        ),
                        Text(
                          "Female",
                          style: descriptionStyleDarkBlur2,
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    ToDoButton(
                      assetName: '',
                      text: 'Register',
                      textColor: Colors.white,
                      backgroundColor: activeButtonBackgroundColor,
                      onPressed: () async {
                        if (_formKey.currentState.validate() &&
                            selectedRole != null &&
                            selectedConstructionId != null &&
                            selectedDate != null) {
                          _formKey.currentState.save();

                          var prefs = await SharedPreferences.getInstance();
                          prefs.setString("userRole", selectedRole);

                          try {
                            await Firestore.instance
                                .collection('userData')
                                .document(widget.user.uid)
                                .updateData({
                              'name': _usernameController.text,
                              'role': selectedRole,
                              'construction_site': {
                                "constructionId": selectedConstructionId,
                                "constructionSite": selectedConstructionSite,
                                "location": GeoPoint(selectedConstructionLat,
                                    selectedConstructionLong)
                              },
                              'date_of_birth': selectedDate,
                              "gender": group,
                              'latitude': currentLocation.latitude,
                              'longitude': currentLocation.longitude,
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
                      //onPressed: model.canSubmit ? () => _imageUpload() : null,
                    ),
                    SizedBox(height: 50.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

//    if (_uploadTask != null) {
//      return StreamBuilder<StorageTaskEvent>(
//          stream: _uploadTask.events == null ? null :_uploadTask.events,
//          builder: (context, snapshot) {
//            var event = snapshot?.data?.snapshot;
//
//            _progressValue =
//            event != null ? event.bytesTransferred / event.totalByteCount : 0;
//
//            return signupContent(
//              Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                LinearProgressIndicator(
//                  value: _progressValue,
//                ),
//                Text('${(_progressValue * 100).round()}%'),
//              ],
//            ),
//            );
//          }
//      );
//    }else{
//      return signupContent(
//          ToDoButton(
//            assetName: 'images/googl-logo.png',
//            text: 'Register',
//            textColor: Colors.white,
//            backgroundColor: activeButtonBackgroundColor,
//            onPressed: model.canSubmit ? () => _imageUpload() : null,
//          ),
//      );
//
//    }
  }

//  Future<void> _submit(String path) async {
//
//    try {
//      FirebaseUser user = await FirebaseAuth.instance.currentUser();
//      final employeeDetails = EmployeeDetails(
//        username: _usernameController.value.text,
//        phoneNumber: '+91${widget.phoneNo}',
//        gender: 'Not mentioned',
//        dateOfBirth: Timestamp.fromDate(selectedDate),
//        joinedDate: Timestamp.fromDate(DateTime.now()),
//        latitude: '',
//        longitude: '',
//        role: 'Not assigned',
//        employeeImagePath: path,
//        deviceToken: DEVICE_TOKEN,
//      );
//
//      await FirestoreService.instance.setData(
//        path: APIPath.employeeDetails(user.uid),
//        data: employeeDetails.toMap(),
//      );
//      GoToPage(context, LandingPage());
//
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Something went wrong.',
//        exception: e,
//      ).show(context);
//    }
//  }
//
//  void _imageUpload() async {
//    _loading = !_loading;
//    if (_profilePic != null ) {
//      String _profilePicPath = 'profile_pic_images/${DateTime.now()}.png';
//      setState(() {
//        _uploadTask =
//            _storage.ref().child(_profilePicPath).putFile(_profilePic);
//      });
//      _profilePicPathURL = await (await _storage
//          .ref()
//          .child(_profilePicPath)
//          .putFile(_profilePic)
//          .onComplete)
//          .ref
//          .getDownloadURL();
//
//      _submit(_profilePicPathURL);
//    }
//  }
}

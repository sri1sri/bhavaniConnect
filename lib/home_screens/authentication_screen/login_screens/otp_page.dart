import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/button_widget/to_do_button.dart';
import 'package:bhavaniconnect/common_variables/firebase_components.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// class OTPPage extends StatelessWidget {
//   OTPPage(
//       {@required this.phoneNo,
//       @required this.verificationId,
//       @required this.newUser});
//   String phoneNo;
//   String verificationId;

//   bool newUser;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: F_OTPPage(),
//     );
//   }
// }

class OTPPage extends StatefulWidget {
  OTPPage({
    @required this.phoneNo,
    @required this.newUser,
    @required this.verificationId,
  });

  String phoneNo;
  bool newUser;
  String verificationId;

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  // PhoneNumberModel get model => widget.model;
  bool _btnEnabled = false;

  Future<bool> didCheckPhoneNumber;

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

//  OtpModel get model => widget.model;

  @override
  void initState() {
    super.initState();
    verificationId = widget.verificationId;
    phoneNo = widget.phoneNo;
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Scaffold(
          body: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[],
        ),
        Column(
          children: <Widget>[
            Text(
              'Verify Mobile Number',
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Enter OTP sent to +91 ${this.phoneNo}.',
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Column(
          children: <Widget>[],
        ),
        Column(
          children: <Widget>[
            new TextFormField(
              keyboardType: TextInputType.number,
              controller: _otpController,
              textInputAction: TextInputAction.done,
              obscureText: false,
              focusNode: _otpFocusNode,
              //onEditingComplete:() =>_submit(),
              //onChanged: model.updateOtp,
              decoration: new InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: backgroundColor,
                ),
                labelText: "Enter OTP",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  smsOTP = value;
                });
              },

              validator: (val) {
                if (val.length == 0) {
                  return "One Time Password cannot be empty";
                } else {
                  return null;
                }
              },
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(height: 20.0),
            ToDoButton(
              assetName: 'images/googe-logo.png',
              text: 'Verify',
              isEnabled: smsOTP != null && smsOTP.length == 6,
              textColor: Colors.white,
              backgroundColor: activeButtonBackgroundColor,
              onPressed: () {
                signIn();
                // GoToPage(context, HomePage());
              },
              //onPressed: model.canSubmit ? () => _submit() : null,
            ),
            SizedBox(height: 10.0),
            ToDoButton(
              assetName: 'images/googe-logo.png',
              text: 'Edit phone number',
              textColor: Colors.black,
              backgroundColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      checkUserInFirestore(user.uid);
                    } else {
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  checkUserInFirestore(String userId) async {
    await usersRef.document(userId).get().then((doc) {
      if (!doc.exists) {
        DocumentReference documentReference = usersRef.document(userId);
        documentReference.setData({
          "phoneNumber": '+91${this.phoneNo}',
          "status": 0,
          "joinedDate": DateTime.now().toUtc(),
        });
      }
      Navigator.of(context).pop();
    });
  }

  signIn() async {
    print(verificationId);
    print(smsOTP);
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      print(credential);
      final AuthResult user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.user.uid == currentUser.uid);
      checkUserInFirestore(currentUser.uid);
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        // _checkForUser(context);
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

//  @override
//  Future<void> _submit() async {
//    try {
//      widget.phoneNo == '8333876209' ? EMPLOYEE_PNO = widget.phoneNo : '';
//      print('otp${widget.newUser}');
//      if(widget.newUser){
//        await model.submit();
//        GoToPage(context, SignUpPage(phoneNo: widget.phoneNo));
//      }else{
//        await model.submit();
//        GoToPage(context, LandingPage());
//      }
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Otp Verification failed',
//        exception: e,
//      ).show(context);
//    }
//  }
}

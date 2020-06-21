import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/button_widget/to_do_button.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/common_widgets/platform_alert/platform_exception_alert_dialog.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/login_screens/otp_page.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/registrtion_screens/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bhavaniconnect/common_variables/firebase_components.dart';

class PhoneNumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_PhoneNumberPage(),
    );
  }
}

class F_PhoneNumberPage extends StatefulWidget {
  @override
  _F_PhoneNumberPageState createState() => _F_PhoneNumberPageState();
}

class _F_PhoneNumberPageState extends State<F_PhoneNumberPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  // PhoneNumberModel get model => widget.model;
  bool _btnEnabled = false;

  Future<bool> didCheckPhoneNumber;

  bool isLoading = false;

  // verifyPhone() {
  //   GoToPage(context, OTPPage());
  // }
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SCREEN_SIZE = MediaQuery.of(context).size;
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
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
              'Enter Mobile Number',
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'To create an Account or SignIn \nuse your phone number.',
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
              controller: _phoneNumberController,
              textInputAction: TextInputAction.done,
              obscureText: false,
              focusNode: _phoneNumberFocusNode,
              // onEditingComplete: () => _submit(context),
              //  onChanged: model.updatePhoneNumber,
              onChanged: (value) {
                setState(() {
                  this.phoneNo = value;
                });
              },
              decoration: new InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: backgroundColor,
                ),
                labelText: "Enter your mobile no.",
                //fillColor: Colors.redAccent,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              // autovalidate: true,
              validator: (val) {
                if (val.length == 0) {
                  return "Phone number cannot be empty";
                } else if (val.length == 10) {
                  return null;
                } else {
                  return "Phone number you entered is invalid.";
                }
              },
              keyboardType: TextInputType.phone,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            (errorMessage != ''
                ? Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  )
                : Container()),
            SizedBox(height: 20.0),
            ToDoButton(
              isEnabled: phoneNo != null && phoneNo.length == 10,
              assetName: '',
              text: 'Get OTP',
              textColor: Colors.white,
              backgroundColor: activeButtonBackgroundColor,
              // onPressed: _btnEnabled ? verifyPhone : null,
              isLoading: isLoading,
              onPressed: verifyPhone,

              // onPressed: () {
              //   GoToPage(context, OTPPage());
              // },
            ),
            SizedBox(height: 10.0),
            ToDoButton(
              assetName: '',
              text: 'back',
              isLoading: isLoading,
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

  Future<void> verifyPhone() async {
    setState(() {
      isLoading = true;
    });
    print(isLoading);

    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      // smsOTPDialog(context).then((value) {
      //   print('sign in');
      // });
      print(verId);

      _checkForUser(context, verId);
    };
    print(isLoading);
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+91${this.phoneNo}', // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 90),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final AuthResult user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.user.uid == currentUser.uid);
      Navigator.of(context).pop();
      GoToPage(context, SignUpPage());
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
        // Navigator.of(context).pop();
        // smsOTPDialog(context).then((value) {
        //   print('sign in');
        // });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  _checkForUser(BuildContext context, String verId) async {
    try {
      usersRef
          .where('phoneNumber',
              isEqualTo: '+91${_phoneNumberController.value.text}')
          .snapshots()
          .listen((data) {
        print('data=$data');
        setState(() {
          isLoading = false;
        });
        if (data.documents.length == 0) {
          // model.submit(),

          GoToPage(
              context,
              OTPPage(
                phoneNo: _phoneNumberController.value.text,
                newUser: true,
                verificationId: verId,
              ));
        } else {
          //model.submit(),
          GoToPage(
              context,
              OTPPage(
                phoneNo: _phoneNumberController.value.text,
                newUser: false,
                verificationId: verId,
              ));
        }
      });
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Phone number failed',
        exception: e,
      ).show(context);
    }
  }
}

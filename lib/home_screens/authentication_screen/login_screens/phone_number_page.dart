import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/button_widget/to_do_button.dart';
import 'package:bhavaniconnect/common_widgets/loading_page.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/login_screens/otp_page.dart';
import'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PhoneNumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_PhoneNumberPage(),
    );
  }
}

class F_PhoneNumberPage extends StatefulWidget {
//  F_PhoneNumberPage({@required this.model});
//  final PhoneNumberModel model;
//
//  static Widget create(BuildContext context) {
//    final AuthBase auth = Provider.of<AuthBase>(context);
//    return ChangeNotifierProvider<PhoneNumberModel>(
//      create: (context) => PhoneNumberModel(auth: auth),
//      child: Consumer<PhoneNumberModel>(
//        builder: (context, model, _) => F_PhoneNumberPage(model: model),
//      ),
//    );
//  }


  @override
  _F_PhoneNumberPageState createState() => _F_PhoneNumberPageState();
}

class _F_PhoneNumberPageState extends State<F_PhoneNumberPage> {

  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneNumberFocusNode = FocusNode();
 // PhoneNumberModel get model => widget.model;

  Future<bool> didCheckPhoneNumber;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget (BuildContext context){
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

    return  Column(
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
            SizedBox(height: 10,),
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
            SizedBox(height: 20.0),
            ToDoButton(
                assetName: 'images/googl-logo.png',
                text: 'Get OTP',
                textColor: Colors.white,
                backgroundColor: activeButtonBackgroundColor,
                onPressed: (){
                  GoToPage(context, OTPPage());
                }
            ),
            SizedBox(height: 10.0),
            ToDoButton(
              assetName: 'images/googl-logo.png',
              text: 'back',
              textColor: Colors.black,
              backgroundColor: Colors.white,
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ],
    );
  }


//  Future<void> _submit(BuildContext context) async {
//    try {
//        await Firestore.instance
//            .collection('employees')
//            .where('employee_contact_number',
//            isEqualTo: '+91${_phoneNumberController.value.text}')
//            .snapshots()
//            .listen((data) => {
//          print('data=${data}'),
//
//          if (data.documents.length == 0)
//            {
//              model.submit(),
//              GoToPage(context, OTPPage(phoneNo: _phoneNumberController.value.text, newUser: true)),
//            }
//          else
//            {
//              model.submit(),
//              GoToPage(context, OTPPage(phoneNo: _phoneNumberController.value.text, newUser: false)),
//            }
//        });
//    } on PlatformException catch (e) {
//      PlatformExceptionAlertDialog(
//        title: 'Phone number failed',
//        exception: e,
//      ).show(context);
//    }
//  }
}
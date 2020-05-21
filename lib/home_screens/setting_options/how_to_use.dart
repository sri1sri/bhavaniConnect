import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/settings.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HowToUse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_HowToUse(),
    );
  }
}

class F_HowToUse extends StatefulWidget {
  @override
  _F_HowToUseState createState() => _F_HowToUseState();
}

class _F_HowToUseState extends State<F_HowToUse> {

  int _n = 0;
  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);

  }

  Widget offlineWidget (BuildContext context){
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize:
        Size.fromHeight(60),
        child: CustomAppBarDark(
          leftActionBar: Icon(Icons.arrow_back_ios,size: 25,color: Colors.white,),
          leftAction: (){
            Navigator.pop(context,true);
          },
          primaryText: 'How To Use',
          tabBarWidget: null,
          rightActionBar: Icon(Icons.settings,size: 25,color: Colors.transparent,),


        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(40.0),
            topLeft: Radius.circular(40.0)),
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 1"," Login to app using your phone number"),
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 2","Open the app Open the app Open the app Open the app Open the app Open the app Open the app Open the app Open the app Open the app Open the app Open the app"),
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 3","Open the app "),
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 4","Open the app "),
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 5","Open the app "),
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 6","Open the app "),
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 7","Open the app "),
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 8","Open the app "),
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 9","Open the app "),
                    SizedBox(height: 10,),
                    _Notificationcard("STEP 10","Open the app "),

                  ],
                ),
              )
          ),
        ),
      ),

    );
  }
  _Notificationcard(String step, String description)
  {
    return Container(

      child: Center(
        child: Card(
          child: Container(
            width: double.infinity,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(step,
                    style: titleStyle,

                  ),
                  SizedBox(height: 15,),
                  Text(description,
                    style: descriptionStyle,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
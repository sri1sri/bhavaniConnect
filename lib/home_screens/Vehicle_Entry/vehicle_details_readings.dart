import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/button_widget/to_do_button.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Vehicle_Entry/add_vehicle_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';
import 'package:vector_math/vector_math.dart' as math;

class AddVehicleDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddVehicleDetails(),
    );
  }
}

class F_AddVehicleDetails extends StatefulWidget {
  @override
  _F_AddVehicleDetails createState() => _F_AddVehicleDetails();
}

class _F_AddVehicleDetails extends State<F_AddVehicleDetails> {
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize:
        Size.fromHeight(70),
        child: CustomAppBarDark(
          leftActionBar: Icon(Icons.arrow_back_ios,size: 25,color: Colors.white,),
          leftAction: (){
            Navigator.pop(context,true);
          },
          //rightActionBar: Icon(Icons.border_color,size: 25,color: Colors.white,),
          rightAction: (){
//            GoToPage(
//                context,
//                AddInvoice(
//                ));
          },
          primaryText: 'Vehicle Details',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0),
            topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50,),
                Text("Records",style: titleStyle,),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  //height: 150,
                  width: MediaQuery.of(context).size.width,

                  child: Padding(
                    padding: const EdgeInsets.only(top:10.0,bottom: 30,left: 5,right: 10),
                    child: DataTable(
                        showCheckboxColumn: false, // <-- this is important
                        columns: [
                          DataColumn(label: Text('Status',style: subTitleStyle,)),
                          DataColumn(label: Text('Time',style: subTitleStyle,)),
                          DataColumn(label: Text('Readings',style: subTitleStyle,)),
                        ],
                        rows:[
                          DataRow(
                            cells: [
                              DataCell(Text('Initial',style: descriptionStyleDark,)),
                              DataCell(Text('10.30am',style: descriptionStyleDark,)),
                              DataCell(Text('62716217',style: descriptionStyleDark,)),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Final',style: descriptionStyleDark,)),
                              DataCell(Text('05.23pm',style: descriptionStyleDark,)),
                              DataCell(Text('62821882',style: descriptionStyleDark,)),
                            ],
                          ),
                        ]
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Text("Approval Status",style: titleStyle,),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  //height: 150,
                  width: MediaQuery.of(context).size.width,

                  child: Padding(
                    padding: const EdgeInsets.only(top:10.0,bottom: 30,left: 5,right: 10),
                    child: DataTable(
                        showCheckboxColumn: false, // <-- this is important
                        columns: [
                          DataColumn(label: Text('Status',style: subTitleStyle,)),
                          DataColumn(label: Text('Name',style: subTitleStyle,)),
                          DataColumn(label: Text('Time',style: subTitleStyle,)),
                        ],
                        rows:[
                          DataRow(
                            cells: [
                              DataCell(Text('Requested By',style: descriptionStyleDark,)),
                              DataCell(Text('Vasanth (Supervisor)',style: descriptionStyleDark,)),
                              DataCell(Text('10.30am',style: descriptionStyleDark,)),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Approved By',style: descriptionStyleDark,)),
                              DataCell(Text('Srivatsav (Manager)',style: descriptionStyleDark,)),
                              DataCell(Text('05.23pm',style: descriptionStyleDark,)),
                            ],
                          ),
                        ]
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Text("Details",style: titleStyle,),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  //height: 150,
                  width: MediaQuery.of(context).size.width,

                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Seller",style: subTitleStyle,),
                        SizedBox(height: 5,),
                        Text("Vasanth transport",style: descriptionStyleDark,),
                        SizedBox(height: 15,),
                        Text("Vehicle No.",style: subTitleStyle,),
                        SizedBox(height: 5,),
                        Text("TN66V6571",style: descriptionStyleDark,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 100,),

              ],
            ),
          ),
        ),
      ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  startReadingDialogue(context,);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.withOpacity(0.8),
                  ),
                  height: 35,
                  width: 80,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("START",style: subTitleStyleLight1,),
                    ],
                  ),
                ),
              ),
//              SizedBox(width: 20,),
//              GestureDetector(
//                onTap: (){
//                  endReadingDialogue(context,);
//                },
//                child: Container(
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(5),
//                    color: Colors.red.withOpacity(0.8),
//                  ),
//                  height: 35,
//                  width: 80,
//
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: [
//                      Text("STOP",style: subTitleStyleLight1,),
//                    ],
//                  ),
//                ),
//              ),
            ],
          ),
        )

    );
  }

}

void startReadingDialogue(BuildContext context,) {

  final _formKey = GlobalKey<FormState>();
  String _updatedGangName;

  showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {},
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierLabel: '',
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.rotate(
          angle: math.radians(anim1.value * 360),
          child: Opacity(
            opacity: anim1.value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  height: 250.0,
                  width: 400.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                            crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Enter Start Readings",style: highlightDescription,),
                                Form(
                                  key: _formKey,
                                  child:
                                  Column(
                                    children: [
                                      TextFormField(
                                        onChanged: (value) => _updatedGangName = value,
                                        autocorrect: true,
                                        obscureText: false,
                                        keyboardType: TextInputType.text,
                                        keyboardAppearance: Brightness.light,
                                        autofocus: true,
                                        cursorColor: backgroundColor,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration:  InputDecoration(
                                          counterStyle: TextStyle(
                                            // fontFamily: mainFontFamily,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          hintText: "ODO Reading",
                                          hintStyle: TextStyle(
                                            // fontFamily: mainFontFamily,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide:
                                            const BorderSide(color: Colors.transparent, width: 0.0),
                                          ),
                                        ),
                                        validator: (value) {
                                          print(value);
                                          if (value.isEmpty) {
                                            return 'Please enter new gang name.';
                                          }
                                          return null;
                                        },
                                      ),

                                    ],
                                  ),
                                ),

                                Container(
                                  height: 55,
                                  width: 180,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
//                                      final updatedGangDetails  = GangDetails(gangName: _updatedGangName);
//                                      DBreference.updateGang(updatedGangDetails, gangDetails.gangID);
//
//                                      GoToPage(context, LandingPage());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Start",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  //fontFamily: mainFontFamily,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 22,decoration: TextDecoration.none),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        // These values are based on trial & error method
                        alignment: Alignment(1.05, -1.05),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300));
}
void endReadingDialogue(BuildContext context,) {

  final _formKey = GlobalKey<FormState>();
  String _updatedGangName;

  showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {},
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierLabel: '',
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.rotate(
          angle: math.radians(anim1.value * 360),
          child: Opacity(
            opacity: anim1.value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  height: 250.0,
                  width: 400.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                            crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Enter End Readings",style: highlightDescription,),
                                Form(
                                  key: _formKey,
                                  child:
                                  Column(
                                    children: [
                                      TextFormField(
                                        onChanged: (value) => _updatedGangName = value,
                                        autocorrect: true,
                                        obscureText: false,
                                        keyboardType: TextInputType.text,
                                        keyboardAppearance: Brightness.light,
                                        autofocus: true,
                                        cursorColor: backgroundColor,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        decoration:  InputDecoration(
                                          counterStyle: TextStyle(
                                            // fontFamily: mainFontFamily,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          hintText: "ODO Reading",
                                          hintStyle: TextStyle(
                                            // fontFamily: mainFontFamily,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide:
                                            const BorderSide(color: Colors.transparent, width: 0.0),
                                          ),
                                        ),
                                        validator: (value) {
                                          print(value);
                                          if (value.isEmpty) {
                                            return 'Please enter new gang name.';
                                          }
                                          return null;
                                        },
                                      ),

                                    ],
                                  ),
                                ),

                                Container(
                                  height: 55,
                                  width: 180,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
//                                      final updatedGangDetails  = GangDetails(gangName: _updatedGangName);
//                                      DBreference.updateGang(updatedGangDetails, gangDetails.gangID);
//
//                                      GoToPage(context, LandingPage());
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "Stop",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  //fontFamily: mainFontFamily,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 22,decoration: TextDecoration.none),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        // These values are based on trial & error method
                        alignment: Alignment(1.05, -1.05),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300));
}
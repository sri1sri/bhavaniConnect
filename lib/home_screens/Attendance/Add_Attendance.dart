import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class AddAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddAttendance(),
    );
  }
}

class F_AddAttendance extends StatefulWidget {
  @override
  _F_AddAttendance createState() => _F_AddAttendance();
}

class _F_AddAttendance extends State<F_AddAttendance> {

  int _counter = 1;

  void confirm() {
    setState(() {
      _counter++;
    });
  }
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
            primaryText: 'Add Attendance',
            tabBarWidget: null,
          ),
        ),
        body:ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0),
              topLeft: Radius.circular(50.0)),
          child: Container(
              color: Colors.white,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: backgroundColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  height: 120,
                                  width: 600,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today,size: 35,color: backgroundColor,),
                                          SizedBox(width: 15,),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Monday",style: descriptionStyleDark,),
                                              SizedBox(height: 8,),
                                              Text("29 Oct 2020",style: subTitleStyleDark1,)
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 5,),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 2,
                                          height: double.maxFinite,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Row(
                                        children: [
                                          Icon(Icons.timer,size: 35,color: backgroundColor,),
                                          SizedBox(width: 15,),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Hours Worked",style: descriptionStyleDark,),
                                              SizedBox(height: 8,),
                                              Text("07:30",style: subTitleStyleDark1,)
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          color: backgroundColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      height: 100,
                                      width: 180,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.call_received,size: 35,color: Colors.green,),
                                              SizedBox(width: 15,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Punch In",style: descriptionStyleDark,),
                                                  SizedBox(height: 8,),
                                                  Text("10.30 am",style: subTitleStyleGreen,)
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                  SizedBox(width: 10,),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: backgroundColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      height: 100,
                                      width: 180,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.call_made,size: 35,color: Colors.red,),
                                              SizedBox(width: 15,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text("Punch Out",style: descriptionStyleDark,),
                                                  SizedBox(height: 8,),
                                                  Text("06.30 pm",style: subTitleStyleRed,)
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 50,),
                            child: ConfirmationSlider(
                              foregroundShape: BorderRadius.circular(15),
                              backgroundShape: BorderRadius.circular(15),
                              text: (_counter%2)== 1 ? "      Slide to Punch In" : "      Slide to Punch Out",
                              textStyle: activeSubTitleStyle,
                              iconColor: Colors.black,
                              backgroundColor: (_counter%2)== 1 ? Colors.green : Colors.red,
                              foregroundColor: Colors.white,
                              onConfirmation: () => confirm(),
                            ),
                          ),
                        ),
                      ]
                  )
              )),
        ),
    );
  }

}

Widget attendanceCard(String day,String month,String year,String inTime,String outTime) {
  return Padding(
    padding: const EdgeInsets.only(top:10.0,bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(15)
          ),
          height: 90,
          width: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(day,style: titleStylelight,),
              Text(month,style: descriptionStyleLite1,),
              Text(year,style: descriptionStyleLite1,)
            ],
          ),
        ),
        SizedBox(width: 10,),
        Container(
            decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)
            ),
            height: 90,
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.call_received,size: 30,color: Colors.green,),
                    SizedBox(width: 7,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Punch In",style: descriptionStyleDark,),
                        SizedBox(height: 5,),
                        Text(inTime,style: subTitleStyleDark1,)
                      ],
                    )
                  ],
                ),
                SizedBox(width: 5,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 2,
                    height: double.maxFinite,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 5,),
                Row(
                  children: [
                    Icon(Icons.call_made,size: 30,color: Colors.red,),
                    SizedBox(width: 7,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Punch Out",style: descriptionStyleDark,),
                        SizedBox(height: 5,),
                        Text(outTime,style: subTitleStyleDark1,)
                      ],
                    )
                  ],
                ),
              ],
            )
        )
      ],
    ),
  );
}

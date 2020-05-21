
import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Display_Employee_Attendance.dart';



class SearchEmployeeAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_SearchEmployeeAttendance(),
    );
  }
}

class F_SearchEmployeeAttendance extends StatefulWidget {
  @override
  _F_SearchEmployeeAttendance createState() => _F_SearchEmployeeAttendance();
}

class _F_SearchEmployeeAttendance extends State<F_SearchEmployeeAttendance> {
  int _n = 0;
  int selectedValue;
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
          primaryText: 'Employee Attendance',
          tabBarWidget: null,
        ),
      ),
      body:ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0),
            topLeft: Radius.circular(50.0)),
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Text("Employee Name",style: titleStyle,),
                  SizedBox(height: 20,),
                  DropdownSearch(
                      showSelectedItem: true,
                      maxHeight: 500,
                      mode: Mode.DIALOG,
                      items: ["Vasanthakumar", "Srivatsav","Vamsi", "Vimal","Rockstar", "Manmandhan",],
                      label: "Employee Name",
                      onChanged: print,
                      selectedItem: "Choose Employee Name",
                      showSearchBox: true),
                  SizedBox(height: 20,),
                  Text("Attendance Month",style: titleStyle,),
                  SizedBox(height: 20,),
                  DropdownSearch(
                      showSelectedItem: true,
                      maxHeight: 500,
                      mode: Mode.DIALOG,
                      items: ["January", "February","March", "April","May", "June","July","August","September","October","November","December"],
                      label: "Month",
                      onChanged: print,
                      selectedItem: "Choose Attendance Month",
                      showSearchBox: true),
                  SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 55,
                        width: 180,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DisplayEmployeeAttendance(),),
                            );
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
                                  child: Text(
                                    "Search",
                                    style: activeSubTitleStyle,
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
    );
  }
}

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
import 'package:flutter/painting.dart';
import 'package:spring_button/spring_button.dart';
import 'package:vector_math/vector_math.dart' as math;

class AddVehicleCountDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddVehicleCountDetails(),
    );
  }
}

class F_AddVehicleCountDetails extends StatefulWidget {
  @override
  _F_AddVehicleCountDetails createState() => _F_AddVehicleCountDetails();
}

class _F_AddVehicleCountDetails extends State<F_AddVehicleCountDetails> {
  final List time = [
    DateTime.now().toIso8601String(),
  ];
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
         // rightActionBar: Icon(Icons.border_color,size: 25,color: Colors.white,),
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
                Text("Trip Records",style: titleStyle,),
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.withOpacity(0.4),
                  ),
                  //height: 150,
                  width: MediaQuery.of(context).size.width,

                  child: Padding(
                    padding: const EdgeInsets.only(top:10.0,bottom: 30,left: 20,right: 20),
                    child: DataTable(
                        showCheckboxColumn: false, // <-- this is important
                        columns: [
                          DataColumn(label: Text('Round',style: subTitleStyle,)),
                          DataColumn(label: Text('Time',style: subTitleStyle,)),
                        ],
                        rows:[
                          DataRow(
                            cells: [
                              DataCell(Text('  1',style: descriptionStyleDark,)),
                              DataCell(Text('10.30am',style: descriptionStyleDark,)),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('  2',style: descriptionStyleDark,)),
                              DataCell(Text('02.13pm',style: descriptionStyleDark,)),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('  3',style: descriptionStyleDark,)),
                              DataCell(Text('04.23pm',style: descriptionStyleDark,)),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('  4',style: descriptionStyleDark,)),
                              DataCell(Text('05.34pm',style: descriptionStyleDark,)),
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
                      Text("ADD",style: subTitleStyleLight1,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
  void addItem(){

    setState(() {
      time.add(time[0]);
      time.length;
    });

  }

}

Widget timeCard(BuildContext context,int count,String time)
{
  return Padding(
    padding:EdgeInsets.all(10),
    child:  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$count",style: descriptionStyleDark,),
        SizedBox(width: 150,),
        Text(time,style: descriptionStyleDark,),
      ],
    ),
  );
}
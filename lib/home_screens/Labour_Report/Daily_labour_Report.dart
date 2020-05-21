import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Labour_Report/Add_report.dart';
import 'package:bhavaniconnect/home_screens/Labour_Report/Detail_Report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Print_Reports.dart';



class LabourEntries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_LabourEntries(),
    );
  }
}

class F_LabourEntries extends StatefulWidget {
  @override
  _F_LabourEntries createState() => _F_LabourEntries();
}

class _F_LabourEntries extends State<F_LabourEntries> {
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
        Size.fromHeight(70),
        child: CustomAppBarDark(
          leftActionBar: Icon(Icons.arrow_back_ios,size: 25,color: Colors.white,),
          leftAction: (){
            Navigator.pop(context,true);
          },
          rightActionBar: Icon(Icons.print,size: 25,color: Colors.white,),
          rightAction: (){
            GoToPage(
                context,
                PrintReport(
                ));
          },
          primaryText: 'Daily Labour Report',
          tabBarWidget: null,
        ),
      ),
      body:ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0),
            topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20,),
//                SingleChildScrollView(
//                  scrollDirection: Axis.horizontal,
//                  child: DataTable(
//                    onSelectAll: (b) {},
//                    sortAscending: true,
//                    showCheckboxColumn: false,
//                    dataRowHeight: 70.0,
//                    columns: <DataColumn>[
//                      DataColumn(label: Text("S.No.",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Created On",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Created By",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Labour Type",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Construction Site",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Block",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Dealer Name",style: subTitleStyle1,)),
//                      DataColumn(label: Text("No. of People ",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Propose",style: subTitleStyle1,)),
//                    ],
//                    rows: items
//                        .map(
//                          (itemRow) => DataRow(onSelectChanged: (b) {GoToPage(
//                          context,
//                              DetailReport());},
//                        cells: [
//                          DataCell(
//                            Text(itemRow.slNo,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.date,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.createdBy,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.labourType,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.site,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.block,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.dealerName,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.noofPeople,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.purpose,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                        ],
//                      ),
//                    )
//                        .toList(),
//                  ),
//                ),
                LabourEntry(size, context,"29 Oct 2020","Bhavani Vivan","Out Sourcing Employess","2A","Plumbing","Vasanth Agencies"),
                SizedBox(height: 600,)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          GoToPage(
              context,
              AddLabourReport(
              ));
        },
        child: Icon(Icons.add),
        backgroundColor: backgroundColor,
      ),
    );
  }
}

class ItemInfo {
  String slNo;
  String createdBy;
  String date;
  String site;
  String block;
  String labourType;
  String dealerName;
  String noofPeople;
  String purpose;

  ItemInfo({
    this.slNo,
    this.createdBy,
    this.date,
    this.site,
    this.block,
    this.labourType,
    this.dealerName,
    this.noofPeople,
    this.purpose,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Self employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"

  ),
  ItemInfo(
      slNo: '2',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Out Sourcing employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"

  ),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      createdBy: "Vasanth (Manager)",
      labourType: "Self employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"

  ),
  ItemInfo(
      slNo: '4',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Out Sourcing employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"

  ),
  ItemInfo(
      slNo: '5',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      labourType: "Self employees",
      dealerName: "Vasanth Agencies",
      noofPeople: "20",
      purpose: "Plumbing"

  ),

];

Widget LabourEntry(Size size, BuildContext context,String date,String site,String labourType,String block,String purpose,String dealerName)
{
  return  GestureDetector(
    onTap: (){
      GoToPage(context,DetailReport());
    },
    child: Padding(
      padding: const EdgeInsets.only(right:15.0,left: 15,top: 20),
      child: Container(
        width: double.infinity,
        height: 210,
        child: Stack(
          children: <Widget>[
            Positioned(
              right:15,
              top: 0,
              child:Text(
                  date,
                  style: descriptionStyleDarkBlur3
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  left: 24,
                  top: 24,
                  right: size.width * .35,
                ),
                height: 185,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA).withOpacity(.45),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        site,
                        style: subTitleStyle1
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Block: $block",
                      style: descriptionStyleDarkBlur1,
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Text(
                          labourType,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleStyleDark1
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                        dealerName,
                        style: subTitleStyle
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                height: 50,
                width: size.width * .40,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                      purpose,
                      style: subTitleStyleLight
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
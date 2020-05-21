import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/Entry_description.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/Print_entries.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/add_concrete_entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ConcreteEntries extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_ConcreteEntries(),
    );
  }
}

class F_ConcreteEntries extends StatefulWidget {
  @override
  _F_ConcreteEntries createState() => _F_ConcreteEntries();
}

class _F_ConcreteEntries extends State<F_ConcreteEntries> {
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
                PrintEntries(
                ));
          },
          primaryText: 'Concrete Entries',
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
//                      DataColumn(label: Text("Concrete Type",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Created On",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Created By",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Construction Site",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Block",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Yesterday's Progress",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Total Progress",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Remarks",style: subTitleStyle1,)),
//                    ],
//                    rows: items
//                        .map(
//                          (itemRow) => DataRow(onSelectChanged: (b) {GoToPage(
//                          context,
//                              EntryDescription());},
//                        cells: [
//                          DataCell(
//                            Text(itemRow.slNo,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.concreteType,style:descriptionStyleDark,),
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
//                            Text(itemRow.yestProg,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.totalProg,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.remarks,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                        ],
//                      ),
//                    )
//                        .toList(),
//                  ),
//                ),
                ConcreteEntry(size, context,"29 Oct 2020","Bhavani Vivan","5T Super strong cement for pillar.","2A","90"),
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
              AddConcreteEntry(
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
  String concreteType;
  String yestProg;
  String totalProg;
  String remarks;

  ItemInfo({
    this.slNo,
    this.date,
    this.createdBy,
    this.site,
    this.block,
    this.concreteType,
    this.yestProg,
    this.totalProg,
    this.remarks,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      concreteType: "Strong Cement",
      block: "8th",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '2',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '3',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '4',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '5',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concreteType: "Strong Cement",
      yestProg: "30",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),

];

Widget ConcreteEntry(Size size, BuildContext context,String date,String site,String concreteType,String block,String total)
{
  return  GestureDetector(
    onTap: (){
      GoToPage(context,EntryDescription());
    },
    child: Padding(
      padding: const EdgeInsets.only(right:15.0,left: 15,top: 20),
      child: Container(
        width: double.infinity,
        height: 190,
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
                height: 165,
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
                          concreteType,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleStyleDark1
                      ),
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
                      "Progress: $total",
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
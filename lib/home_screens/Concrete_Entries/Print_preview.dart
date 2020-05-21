import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrintPreviewConcrete extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_PrintPreviewConcrete(),
    );
  }
}

class F_PrintPreviewConcrete extends StatefulWidget {
  @override
  _F_PrintPreviewConcrete createState() => _F_PrintPreviewConcrete();
}

class _F_PrintPreviewConcrete extends State<F_PrintPreviewConcrete> {
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
          rightActionBar: Icon(Icons.print,size: 25,color: Colors.white),
          rightAction: (){
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Print Preview',
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
                Column(
                  children: [
                    Text("21 October to 30 November",style: subTitleStyleDark1,),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Bhavani Vivan (Block-1)",style: descriptionStyleDarkBlur2,),
                        Text(" | ",style: descriptionStyleDarkBlur2,),
                        Text("SuperStrong",style: descriptionStyleDarkBlur2,),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    onSelectAll: (b) {},
                    sortAscending: true,
                    showCheckboxColumn: false,
                    dataRowHeight: 70.0,
                    columns: <DataColumn>[
                      DataColumn(label: Text("S.No.",style: subTitleStyle1,)),
                      DataColumn(label: Text("Concrete Type",style: subTitleStyle1,)),
                      DataColumn(label: Text("Created On",style: subTitleStyle1,)),
                      DataColumn(label: Text("Created By",style: subTitleStyle1,)),
                      DataColumn(label: Text("Construction Site",style: subTitleStyle1,)),
                      DataColumn(label: Text("Block",style: subTitleStyle1,)),
                      DataColumn(label: Text("Total Progress",style: subTitleStyle1,)),
                      DataColumn(label: Text("Remarks",style: subTitleStyle1,)),
                    ],
                    rows: items
                        .map(
                          (itemRow) => DataRow(onSelectChanged: (b) {},
                        cells: [
                          DataCell(
                            Text(itemRow.slNo,style:descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(itemRow.concType,style:descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(itemRow.date,style:descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(itemRow.createdBy,style:descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(itemRow.site,style:descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(itemRow.block,style:descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(itemRow.totalProg,style:descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                          DataCell(
                            Text(itemRow.remarks,style:descriptionStyleDark,),
                            showEditIcon: false,
                            placeholder: false,
                          ),
                        ],
                      ),
                    )
                        .toList(),
                  ),
                ),
                SizedBox(height: 500,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ItemInfo {
  String slNo;
  String date;
  String site;
  String block;
  String createdBy;
  String concType;
  String totalProg;
  String remarks;

  ItemInfo({

    this.slNo,
    this.date,
    this.createdBy,
    this.site,
    this.concType,
    this.block,
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
      block: "8th",
      concType: "Super Strong",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '2',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concType: "Super Strong",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '3',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concType: "Super Strong",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '3',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concType: "Super Strong",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '4',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      concType: "Super Strong",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),

];



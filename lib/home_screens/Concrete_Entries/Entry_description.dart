import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Add_Progress&Remarks.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/add_Site_Activity.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/AddNewInvoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EntryDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_EntryDescription(),
    );
  }
}

class F_EntryDescription extends StatefulWidget {
  @override
  _F_EntryDescription createState() => _F_EntryDescription();
}

class _F_EntryDescription extends State<F_EntryDescription> {
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
            primaryText: 'Entry Details',
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
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subtext("Created On", "29/Oct/2020"),
                              subtext("Created By", "Vasanth (Manager)"),
                              subtext("Site", "Bhavani Vivan"),
                              subtext("Block", "2nd"),
                              subtext("Concrete Type", "Super Strong"),
                              Divider(
                                thickness: 1,
                                color: Colors.black45,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  onSelectAll: (b) {},
                                  sortAscending: true,
                                  showCheckboxColumn: false,
                                  dataRowHeight: 70.0,
                                  columns: <DataColumn>[
                                    DataColumn(label: Text("S.No.",style: subTitleStyle1,)),
                                    DataColumn(label: Text("Date",style: subTitleStyle1,)),
                                    DataColumn(label: Text("Yesterday’s\nProgress",style: subTitleStyle1,)),
                                    DataColumn(label: Text("Total\nProgress",style: subTitleStyle1,)),
                                    DataColumn(label: Text("Added By",style: subTitleStyle1,)),
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
                                          Text(itemRow.date,style:descriptionStyleDark,),
                                          showEditIcon: false,
                                          placeholder: false,
                                        ),
                                        DataCell(
                                          Text(itemRow.yestProg,style:descriptionStyleDark,),
                                          showEditIcon: false,
                                          placeholder: false,
                                        ),
                                        DataCell(
                                          Text(itemRow.totalprog,style:descriptionStyleDark,),
                                          showEditIcon: false,
                                          placeholder: false,
                                        ),
                                        DataCell(
                                          Text(itemRow.addedBy,style:descriptionStyleDark,),
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
                              Divider(
                                thickness: 1,
                                color: Colors.black45,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Remarks:",style: subTitleStyle ,),
                                    SizedBox(height: 5,),
                                    Text("Transfer from store to construction site",style: descriptionStyleDarkBlur1,)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 550,),
                      ]
                  )
              )),
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
                  GoToPage(
                      context,
                      AddProgressRemarks(
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: backgroundColor,
                  ),
                  height: 40,
                  width: 90,

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
}

Widget subtext(String _left, String _right) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
            '$_left :',
            style: subTitleStyle
        ),
        Text(
            '$_right',
            style: descriptionStyleDarkBlur1
        ),
      ],
    ),
  );
}

Widget totalsubtext(String _left, String _right) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
            '$_left :',
            style: titleStyle
        ),
        Text(
            '$_right',
            style: highlight
        ),
      ],
    ),
  );
}


class ItemInfo {
  String slNo;
  String date;
  String yestProg;
  String totalprog;
  String addedBy;
  String remarks;

  ItemInfo({
    this.slNo,
    this.date,
    this.yestProg,
    this.totalprog,
    this.addedBy,
    this.remarks,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '2',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '4',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '5',
      date: '29/Oct/2020',
      yestProg: "30",
      totalprog: "220",
      addedBy: "Manager",
      remarks: 'Transfer from store to cnstruction Site'

  ),
];
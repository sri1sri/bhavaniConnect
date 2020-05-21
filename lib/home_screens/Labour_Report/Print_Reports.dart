import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/Print_preview.dart';
import 'package:bhavaniconnect/home_screens/Labour_Report/print_preview.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/print_preview.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/site_Activities_HomePage.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_PrintReport(),
    );
  }
}

class F_PrintReport extends StatefulWidget {
  @override
  _F_PrintReport createState() => _F_PrintReport();
}

class _F_PrintReport extends State<F_PrintReport> {
  DateTime selectedDateFrom = DateTime.now();
  DateTime selectedDateTo = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");
  Future<Null> showPickerFrom(BuildContext context) async {
    final DateTime pickedFrom = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1930),
      lastDate: DateTime(2010),
    );
    if (pickedFrom != null){
      setState(() {
        print(customFormat.format(pickedFrom));
        selectedDateFrom = pickedFrom;
      });
    }
  }
  Future<Null> showPickerTo(BuildContext context) async {
    final DateTime pickedTo = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1930),
      lastDate: DateTime(2010),
    );
    if (pickedTo != null){
      setState(() {
        print(customFormat.format(pickedTo));
        selectedDateTo = pickedTo;
      });
    }
  }
  final _formKey = GlobalKey<FormState>();
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
          rightActionBar: Container(width: 10,),
          rightAction: (){
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Print Reports',
          tabBarWidget: null,
        ),
      ),
      body:ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0),
            topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Construction Site",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 400,
                              mode: Mode.MENU,
                              items: ["Bhavani Vivan", "Bahavani Aravindham","Bhavani Vivan", "Bahavani Aravindham","Bhavani Vivan", "Bahavani Aravindham",],
                              label: "Construction Site",
                              onChanged: print,
                              selectedItem: "Choose Construction Site",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Block",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 400,
                              mode: Mode.MENU,
                              items: ["1st", "2nd", "3rd", "4th"],
                              label: "Block",
                              onChanged: print,
                              selectedItem: "Choose Block",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Labour Type",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 400,
                              mode: Mode.MENU,
                              items: ["Self Employees","Out Sourcing Employees"],
                              label: "Labour Type",
                              onChanged: print,
                              selectedItem: "Choose Labour Type",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Dealer Name",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 400,
                              mode: Mode.MENU,
                              items: ["Vasanth Agencies", "Vatsav constructions", "Vamsi Workers"],
                              label: "Dealer Name",
                              onChanged: print,
                              selectedItem: "Choose Dealer Name",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width / 2 - 25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("From",style: titleStyle,),
                                    SizedBox(height: 15,),
                                    GestureDetector(
                                      onTap: () => showPickerFrom(context),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              size: 18.0,
                                              color: backgroundColor,
                                            ),
                                            SizedBox(width: 10,),
                                            Text(
                                                '${customFormat2.format(selectedDateFrom)}',
                                                style: subTitleStyle
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2 - 25,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("To",style: titleStyle,),
                                    SizedBox(height: 15,),
                                    GestureDetector(
                                      onTap: () => showPickerTo(context),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.date_range,
                                              size: 18.0,
                                              color: backgroundColor,
                                            ),
                                            SizedBox(width: 10,),
                                            Text(
                                                '${customFormat2.format(selectedDateTo)}',
                                                style: subTitleStyle
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
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
                                MaterialPageRoute(builder: (context) => PrintPreviewLabour(),),
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
                                      "Preview",
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
                    SizedBox(height: 300,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Concrete_Entries/Concrete_HomePage.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/site_Activities_HomePage.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math.dart' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddConcreteEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddConcreteEntry(),
    );
  }
}

class F_AddConcreteEntry extends StatefulWidget {
  @override
  _F_AddConcreteEntry createState() => _F_AddConcreteEntry();
}

class _F_AddConcreteEntry extends State<F_AddConcreteEntry> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateInvoice = DateTime.now();
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
        selectedDate = pickedFrom;
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
        selectedDateInvoice = pickedTo;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _yesterdayProgressController = TextEditingController();
  final FocusNode _yesterdayProgressFocusNode = FocusNode();
  final TextEditingController _totalprogressController = TextEditingController();
  final FocusNode _totalprogressFocusNode = FocusNode();
  final TextEditingController _remarkController = TextEditingController();
  final FocusNode _remarkFocusNode = FocusNode();
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
          primaryText: 'Add Entry',
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
                          Text("Date",style: titleStyle,),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: () => showPickerFrom(context),
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    size: 30.0,
                                    color: backgroundColor,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                      '${customFormat2.format(selectedDate)}',
                                      style: highlightDescription
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
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
                          Text("Concrete Type",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 400,
                              mode: Mode.MENU,
                              items: ["Iron", "Steel", "Sand" ,"Cement","Bricks"],
                              label: "Concrete Type",
                              onChanged: print,
                              selectedItem: "Choose Concrete Type",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Remarks",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _remarkController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'Remarks cant\'t be empty.',
                            focusNode: _remarkFocusNode,
                            //onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.list,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Remarks',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),


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
                                MaterialPageRoute(builder: (context) => ConcreteEntries(),),
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
                                      "Create",
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
                    SizedBox(height: 50,),
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



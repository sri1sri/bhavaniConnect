import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/site_Activities_HomePage.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_SearchActivity(),
    );
  }
}

class F_SearchActivity extends StatefulWidget {
  @override
  _F_SearchActivity createState() => _F_SearchActivity();
}

class _F_SearchActivity extends State<F_SearchActivity> {

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
          primaryText: 'Search Activity',
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
                              maxHeight: 500,
                              mode: Mode.DIALOG,
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
                          Text("Category",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 400,
                              mode: Mode.MENU,
                              items: ["Iron", "Steel", "Sand" ,"Cement","Bricks"],
                              label: "Category",
                              onChanged: print,
                              selectedItem: "Choose Category",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Sub Category",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 400,
                              mode: Mode.MENU,
                              items: ["Vasanth steels", "Sri Cements", "Vamsi Bricks"],
                              label: "Sub Category",
                              onChanged: print,
                              selectedItem: "Choose Sub Category",
                              showSearchBox: true),
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
                                MaterialPageRoute(builder: (context) => SiteActivities(),),
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


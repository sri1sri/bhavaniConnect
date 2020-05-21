
import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Display_Goods.dart';

class AddGoods extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddGoods(),
    );
  }
}

class F_AddGoods extends StatefulWidget {
  @override
  _F_AddGoods createState() => _F_AddGoods();
}

class _F_AddGoods extends State<F_AddGoods> {

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
          primaryText: 'Add Goods',
          tabBarWidget: null,
        ),
      ),
      body:ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0),
            topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          height: double.infinity,
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
                              items: ["Bhavani Vivan", "Bhavani Aravindam", "Bhavani Vivan", "Bhavani Aravindam",],
                              label: "Construction Site",
                              onChanged: print,
                              selectedItem: "Choose Construction Site",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Category",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 400,
                              mode: Mode.MENU,
                              items: ["Iron", "Steel", "Wood", "Cement"],
                              label: "Category",
                              onChanged: print,
                              selectedItem: "Choose Category",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Dealer Name",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 400,
                              mode: Mode.MENU,
                              items: ["Vasanth steels", "Sri Cements", "Vamsi Bricks"],
                              label: "Dealer Name",
                              onChanged: print,
                              selectedItem: "Choose Dealer Name",
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
                              GoToPage(
                                  context,
                                  GoodsScreen(
                                  ));
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

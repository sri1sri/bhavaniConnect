
import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AddNewInvoice.dart';

class DetailDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_DetailDescription(),
    );
  }
}

class F_DetailDescription extends StatefulWidget {
  @override
  _F_DetailDescription createState() => _F_DetailDescription();
}

class _F_DetailDescription extends State<F_DetailDescription> {
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
            rightActionBar: Icon(Icons.border_color,size: 25,color: Colors.white,),
            rightAction: (){
              GoToPage(
                  context,
                  AddInvoice(
                  ));
            },
            primaryText: 'Stock Details',
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
                              subtext("Created On", "03/Nov/2020"),
                              subtext("Created By", "Vasanth (Manager)"),
                              subtext("Purchased Date", "29/Oct/2020"),
                              subtext("Site", "Bhavani Vivan"),
                              subtext("Item\nDescription", "28 Tons of TMT rods"),
                              subtext("Category", "Iron/Steel"),
                              subtext("Uom", "tons"),
                              subtext("Supplier name", "Vasanth Steels"),
                              subtext("Invoice No.", "63746"),
                              subtext("Received Quantity", "440"),
                              subtext("Issued Quantity", "340"),
                              subtext("Balance Quantity", "100"),
                              subtext("Rate", "₹4732.00"),
                              subtext("Sub Total", "₹4732.00"),
                              subtext("GST Amount", "₹222.00"),
                              Divider(
                                thickness: 1,
                                color: Colors.black54,
                              ),
                              totalsubtext("Total Amount","₹33,732.00"),
                              Divider(
                                thickness: 1,
                                color: Colors.black54,
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
                        SizedBox(height: 150,),
                      ]
                  )
              )),
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


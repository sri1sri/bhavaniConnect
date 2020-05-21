import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/add_Site_Activity.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/detail_description.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/print_Activity.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/search_Activity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SiteActivities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_SiteActivities(),
    );
  }
}

class F_SiteActivities extends StatefulWidget {
  @override
  _F_SiteActivities createState() => _F_SiteActivities();
}

class _F_SiteActivities extends State<F_SiteActivities> {
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
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15,),
              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: 45,
                        left: 20,
                      ),
                      child: InkWell(
                        child: Icon(Icons.arrow_back_ios,size: 25,color: Colors.white,),
                        onTap: (){
                          Navigator.pop(context,true);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                           Text(
                            "Site Activities",
                            textAlign: TextAlign.center,
                            style: appBarTitleStyle,
                          ),
                        ],

                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 35,
                        right: 20,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.search,size: 25,color: Colors.white,),
                            onPressed: (){
                              GoToPage(
                                  context,
                                  SearchActivity(
                                  ));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.print,size: 25,color: Colors.white,),
                              onPressed: (){
                                GoToPage(
                                    context,
                                    PrintActivity(
                                    ));
                              },
                          )
                        ],
                      )
                    ),
                  ],
                ),
              ),
            ],

          ),
        )
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

                SiteActivity(size, context,"29 Oct 2020","Bhavani Vivan","28 Tons of TMT rods with steel blend.","Iron/Steel","2A","90"),
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
              AddSiteActivity(
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
  String date;
  String createdBy;
  String site;
  String block;
  String category;
  String uom;
  String subCategory;
  String yesterdayProg;
  String totalProg;
  String remarks;

  ItemInfo({
    this.slNo,
    this.createdBy,
    this.date,
    this.site,
    this.category,
    this.uom,
    this.block,
    this.subCategory,
    this.yesterdayProg,
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
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '2',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      createdBy: "Vasanth (Manager)",
      block: "8th",
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      createdBy: "Vasanth (Manager)",
      site: 'Bhavani Vivan',
      block: "8th",
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '3',
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      createdBy: "Vasanth (Manager)",
      block: "8th",
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '4',
      createdBy: "Vasanth (Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      block: "8th",
      category: 'Iron/Steel',
      subCategory: 'TMT rod',
      uom: 'Tons',
      yesterdayProg: "20",
      totalProg: "60",
      remarks: 'Transfer from store to cnstruction Site'

  ),

];


Widget SiteActivity(Size size, BuildContext context,String date,String site,String description,String category,String block,String total)
{
  return  GestureDetector(
    onTap: (){
      GoToPage(context,ActivityDetailDescription());
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
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: subTitleStyleDark1
                      ),
                    ),
                    Text(
                        category,
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
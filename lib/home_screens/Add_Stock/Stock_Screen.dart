import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_constants.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Add_Stock/Add_Stock_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StockScreen extends StatefulWidget {
  final String currentUserId;

  const StockScreen({Key key, this.currentUserId}) : super(key: key);
  @override
  _StockScreen createState() => _StockScreen();
}

class _StockScreen extends State<StockScreen> {
  var Stock = [
    "Item",
    "Category",
    "Sub Category",
    "Dealer",
    "Role",
    "Construction Site",
    "Unit"
  ];
  List<String> F_image = [
    "images/s1.png",
    "images/s2.png",
    "images/s6.png",
    "images/s3.png",
    "images/s4.png",
    "images/s5.png",
    "images/s7.png",
  ];
  List<String> F_collection = [
    AppConstants.prod + "items",
    AppConstants.prod + "category",
    AppConstants.prod + "subCategory",
    AppConstants.prod + "dealer",
    AppConstants.prod + "role",
    AppConstants.prod + "constructionSite",
    AppConstants.prod + "units",
  ];
  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
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
        preferredSize: Size.fromHeight(72),
        child: CustomAppBarDark(
          leftActionBar: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.white,
          ),
          leftAction: () {
            Navigator.pop(context, true);
          },
          rightActionBar: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: backgroundColor,
          ),
          primaryText: 'Catalog',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: GridView.builder(
                      itemCount: Stock.length,
                      gridDelegate:
                      new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 2.0,
                        crossAxisSpacing: 2.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return new GestureDetector(
                          child: new Card(
                            elevation: 0.0,
                            child: new Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              alignment: Alignment.center,
                              margin: new EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 5.0,
                                  left: 5.0,
                                  right: 5.0),
                              child: new Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    F_image[index],
                                    height: getDynamicHeight(60),
                                  ),
                                  new Text(
                                    Stock[index],
                                    style: subTitleStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            GoToPage(
                                context,
                                AddStockScreen(
                                  title: Stock[index],
                                  collectionName: F_collection[index],
                                ));
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: getDynamicHeight(500),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoodsEmptyContent extends StatelessWidget {

  final String title;
  final String message;

  const GoodsEmptyContent({Key key, this.title = 'Emptyyyyy!!!', this.message ='No items has been added.'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: getDynamicHeight(20)),
            Text(title, style: TextStyle(fontSize: getDynamicTextSize(30), color: Colors.blueGrey),
            ),
            SizedBox(height: getDynamicHeight(10)),
            Text(message, style: TextStyle(fontSize: getDynamicTextSize(18), color: Colors.blueGrey,fontWeight: FontWeight.w600),
            ),
            SizedBox(height: getDynamicHeight(40),),
          ],
        ),
      ),
    );
  }
}

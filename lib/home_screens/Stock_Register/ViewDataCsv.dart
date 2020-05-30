import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:path/path.dart';

class LoadAndViewCsvPage extends StatelessWidget {
  final String path;
  const LoadAndViewCsvPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBarDark(
          leftActionBar: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.white,
          ),
          leftAction: () {
            Navigator.pop(context, true);
          },
          rightActionBar: Icon(Icons.share, size: 25, color: Colors.white),
          rightAction: () async {
            shareFile();
          },
          primaryText: 'Stock Register',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: double.infinity,
                  height: 60.0,
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          basename(path),
                          style: subTitleStyleDark1,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        "csv",
                        style: descriptionStyleDarkBlur2,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 500.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // load csv as string and transform to List<List<dynamic>>
  /*
  [
    ['Name', 'Coach', 'Players'],
    ['Name1', 'Coach1', '5'],
    etc
  ]
  */
  shareFile() async {
    ShareExtend.share(path, "file");
  }
}

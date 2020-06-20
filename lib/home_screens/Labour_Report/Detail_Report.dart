import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/no_data_widget.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class DetailReport extends StatefulWidget {
  final String currentUserId;
  final String documentId;

  const DetailReport({Key key, this.currentUserId, this.documentId})
      : super(key: key);
  @override
  _DetailReport createState() => _DetailReport();
}

class _DetailReport extends State<DetailReport> {
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
          primaryText: 'Detail Report',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
            color: Colors.white,
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection(AppConstants.prod + "labourReport")
                  .orderBy('added_on', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var result = snapshot.data.documents;
                  if (result.length == 0) {
                    return NoDataWidget();
                  }

                  return SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              subtext(
                                "Created On",
                                DateTimeUtils.slashDateFormat(
                                    (result[0]['added_on'] as Timestamp)
                                        .toDate()),
                              ),
                              subtext(
                                "Selected Date",
                                DateTimeUtils.slashDateFormat(
                                    (result[0]['selected_date'] as Timestamp)
                                        .toDate()),
                              ),
                              subtext("Created By",
                                  "${result[0]['created_by']['name']}  (${result[0]['created_by']['role']})"),
                              subtext(
                                  "Site",
                                  result[0]['construction_site']
                                      ['constructionSite']),
                              subtext("Block", result[0]['block']['blockName']),
                              subtext("Labour Type", result[0]['labour_type']),
                              subtext("Dealer Name",
                                  result[0]['dealer']['dealerName']),
                              subtext(
                                  "No. of People", result[0]['no_of_people']),
                              subtext("Purpose", result[0]['purpose']),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 550,
                        ),
                      ]));
                }
              },
            )),
      ),
    );
  }
}

Widget subtext(String _left, String _right) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('$_left :', style: subTitleStyle),
        Text('$_right', style: descriptionStyleDarkBlur1),
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
        Text('$_left :', style: titleStyle),
        Text('$_right', style: highlight),
      ],
    ),
  );
}

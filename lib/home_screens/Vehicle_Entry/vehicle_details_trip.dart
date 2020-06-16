import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Vehicle_Entry/vehicle_details_readings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AddVehicleCountDetails extends StatefulWidget {
  final String currentUserId;
  final String documentId;
  const AddVehicleCountDetails({Key key, this.currentUserId, this.documentId})
      : super(key: key);
  @override
  _AddVehicleCountDetails createState() => _AddVehicleCountDetails();
}

class _AddVehicleCountDetails extends State<AddVehicleCountDetails> {
  final List time = [
    DateTime.now().toIso8601String(),
  ];
  int _n = 0;
  int index = 0;

  List<Timestamp> timeRecords = [];
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
            // rightActionBar: Icon(Icons.border_color,size: 25,color: Colors.white,),
            rightAction: () {
//            GoToPage(
//                context,
//                AddInvoice(
//                ));
            },
            primaryText: 'Vehicle Details',
            tabBarWidget: null,
          ),
        ),
        body: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("vehicleEntries")
                      .document(widget.documentId)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      var result = snapshot.data;

                      if (result != null && result['timeRecords'] != null) {
                        timeRecords = [];
                        index = 0;
                        print(timeRecords);
                        for (int i = 0; i < result['timeRecords'].length; i++) {
                          timeRecords
                              .add(result['timeRecords'][i] as Timestamp);
                        }
                        // timeRecords = result['timeRecords'] as List<Timestamp>;

                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            "Trip Records",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            //height: 150,
                            width: MediaQuery.of(context).size.width,

                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 30, left: 20, right: 20),
                              child: DataTable(
                                showCheckboxColumn:
                                    false, // <-- this is important
                                columns: [
                                  DataColumn(
                                      label: Text(
                                    'Round',
                                    style: subTitleStyle,
                                  )),
                                  DataColumn(
                                      label: Text(
                                    'Time',
                                    style: subTitleStyle,
                                  )),
                                ],
                                rows: result['timeRecords'] == null
                                    ? []
                                    : timeRecords.map((record) {
                                        index++;
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(
                                              '  $index',
                                              style: descriptionStyleDark,
                                            )),
                                            DataCell(Text(
                                              DateTimeUtils.hourMinuteFormat(
                                                  (record).toDate()),
                                              style: descriptionStyleDark,
                                            )),
                                          ],
                                        );
                                      }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Approval Status",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            //height: 150,
                            width: MediaQuery.of(context).size.width,

                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 30, left: 5, right: 10),
                              child: DataTable(
                                  showCheckboxColumn:
                                      false, // <-- this is important
                                  columns: [
                                    DataColumn(
                                        label: Text(
                                      'Status',
                                      style: subTitleStyle,
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Name',
                                      style: subTitleStyle,
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Time',
                                      style: subTitleStyle,
                                    )),
                                  ],
                                  rows: [
                                    DataRow(
                                      cells: [
                                        DataCell(Text(
                                          'Requested By',
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          "${result['created_by']['name']}  (${result['created_by']['role']})",
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          result['created_by']['at'] != null
                                              ? DateTimeUtils.hourMinuteFormat(
                                                  (result['created_by']['at']
                                                          as Timestamp)
                                                      .toDate())
                                              : '-',
                                          style: descriptionStyleDark,
                                        )),
                                      ],
                                    ),
                                    DataRow(
                                      cells: [
                                        DataCell(Text(
                                          'Approved By',
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          result['approved_by']['name'] !=
                                                      null &&
                                                  result['approved_by']['name']
                                                      .isNotEmpty
                                              ? "${result['approved_by']['name']}  (${result['approved_by']['role']})"
                                              : "-",
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          result['approved_by']['at'] != null
                                              ? DateTimeUtils.hourMinuteFormat(
                                                  (result['approved_by']['at']
                                                          as Timestamp)
                                                      .toDate())
                                              : '-',
                                          style: descriptionStyleDark,
                                        )),
                                      ],
                                    ),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Details",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            //height: 150,
                            width: MediaQuery.of(context).size.width,

                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Seller",
                                    style: subTitleStyle,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    result['dealer']['dealerName'],
                                    style: descriptionStyleDark,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Vehicle No.",
                                    style: subTitleStyle,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${result['vehicleNumber']} (${result['unitsPerTrip'] ?? ''} ${result['units']['unitName'] ?? ''})",
                                    style: descriptionStyleDark,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      );
                    }
                  }),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  timeRecords.add(Timestamp.fromDate(DateTime.now()));
                  print(timeRecords);
                  Firestore.instance
                      .collection("vehicleEntries")
                      .document(widget.documentId)
                      .updateData({
                    'timeRecords': timeRecords,
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.green.withOpacity(0.8),
                  ),
                  height: 35,
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ADD",
                        style: subTitleStyleLight1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void addItem() {
    setState(() {
      time.add(time[0]);
      time.length;
    });
  }
}

Widget timeCard(BuildContext context, int count, String time) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$count",
          style: descriptionStyleDark,
        ),
        SizedBox(
          width: 150,
        ),
        Text(
          time,
          style: descriptionStyleDark,
        ),
      ],
    ),
  );
}

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
// import 'package:bhavaniconnect/common_variables/app_functions.dart';
// import 'package:bhavaniconnect/common_widgets/button_widget/to_do_button.dart';
// import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:bhavaniconnect/home_screens/Vehicle_Entry/add_vehicle_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:spring_button/spring_button.dart';
import 'package:vector_math/vector_math.dart' as math;

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class AddVehicleDetails extends StatefulWidget {
  final String currentUserId;
  final String documentId;
  const AddVehicleDetails({
    Key key,
    this.currentUserId,
    this.documentId,
  }) : super(key: key);

  @override
  _AddVehicleDetails createState() => _AddVehicleDetails();
}

class _AddVehicleDetails extends State<AddVehicleDetails> {
  final TextEditingController _startReadController = TextEditingController();

  final TextEditingController _endReadController = TextEditingController();
  int _n = 0;

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
    bool showStartBtn = false;
    bool showEndBtn = false;
    return StreamBuilder(
      stream: Firestore.instance
          .collection(AppConstants.prod + 'vehicleEntries')
          .document(widget.documentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var vehicleData = snapshot.data;
        String requestDateTime = DateTimeUtils.dayMonthYearTimeFormat(
            (vehicleData['added_on'] as Timestamp).toDate());

        if (vehicleData['endRead'] != null) {
          showStartBtn = false;
          showEndBtn = false;
        } else if (vehicleData['startRead'] != null) {
          showStartBtn = false;
          showEndBtn = true;
        } else {
          showStartBtn = true;
          showEndBtn = false;
        }
        print('$showStartBtn ---------- start');
        print('$showEndBtn ---------- end');

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
              //rightActionBar: Icon(Icons.border_color,size: 25,color: Colors.white,),
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
                topRight: Radius.circular(50.0),
                topLeft: Radius.circular(50.0)),
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: getDynamicHeight(50),
                    ),
                    Text(
                      "Records",
                      style: titleStyle,
                    ),
                    SizedBox(
                      height: getDynamicHeight(20),
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
                            showCheckboxColumn: false, // <-- this is important
                            columns: [
                              DataColumn(
                                  label: Text(
                                'Status',
                                style: subTitleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                'Time',
                                style: subTitleStyle,
                              )),
                              DataColumn(
                                  label: Text(
                                'Readings',
                                style: subTitleStyle,
                              )),
                            ],
                            rows: [
                              vehicleData['startRead'] != null
                                  ? DataRow(
                                      cells: [
                                        DataCell(Text(
                                          'Initial',
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          DateTimeUtils.hourMinuteFormat(
                                              (vehicleData['startTime']
                                                      as Timestamp)
                                                  .toDate()),
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          vehicleData['startRead'],
                                          style: descriptionStyleDark,
                                        )),
                                      ],
                                    )
                                  : DataRow(
                                      cells: [
                                        DataCell(Text(
                                          'Initial',
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          '-----',
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          '-----',
                                          style: descriptionStyleDark,
                                        )),
                                      ],
                                    ),
                              vehicleData['endRead'] != null
                                  ? DataRow(
                                      cells: [
                                        DataCell(Text(
                                          'Final',
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          DateTimeUtils.hourMinuteFormat(
                                              (vehicleData['endTime']
                                                      as Timestamp)
                                                  .toDate()),
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          vehicleData['endRead'],
                                          style: descriptionStyleDark,
                                        )),
                                      ],
                                    )
                                  : DataRow(
                                      cells: [
                                        DataCell(Text(
                                          'Final',
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          '-----',
                                          style: descriptionStyleDark,
                                        )),
                                        DataCell(Text(
                                          '-----',
                                          style: descriptionStyleDark,
                                        )),
                                      ],
                                    ),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: getDynamicHeight(30),
                    ),
                    Text(
                      "Approval Status",
                      style: titleStyle,
                    ),
                    SizedBox(
                      height: getDynamicHeight(20),
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
                            top: 10.0, bottom: 30, left: 0, right: 20),
                        child: DataTable(
                            showCheckboxColumn: false, // <-- this is important
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
                                    //Vasanth (Supervisor)
                                    '${vehicleData['created_by']['name']} (${vehicleData['created_by']['role']})',
                                    style: descriptionStyleDark,
                                  )),
                                  DataCell(Text(
                                    vehicleData['created_by']['at'] != null
                                        ? DateTimeUtils.hourMinuteFormat(
                                            (vehicleData['created_by']['at']
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
                                    vehicleData['approved_by']['name'] !=
                                                null &&
                                            vehicleData['approved_by']['name']
                                                .isNotEmpty
                                        ? '${vehicleData['approved_by']['name']} (${vehicleData['approved_by']['role']})'
                                        : "-",
                                    style: descriptionStyleDark,
                                  )),
                                  DataCell(Text(
                                    vehicleData['approved_by']['at'] != null
                                        ? DateTimeUtils.hourMinuteFormat(
                                            (vehicleData['approved_by']['at']
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
                      height: getDynamicHeight(30),
                    ),
                    Text(
                      "Details",
                      style: titleStyle,
                    ),
                    SizedBox(
                      height: getDynamicHeight(20),
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
                              height: getDynamicHeight(5),
                            ),
                            Text(
                              vehicleData['dealer']['dealerName'],
                              style: descriptionStyleDark,
                            ),
                            SizedBox(
                              height: getDynamicHeight(15),
                            ),
                            Text(
                              "Vehicle No.",
                              style: subTitleStyle,
                            ),
                            SizedBox(
                              height: getDynamicHeight(5),
                            ),
                            Text(
                              "${vehicleData['vehicleNumber']} (${vehicleData['unitsPerTrip'] ?? ''} ${vehicleData['units']['unitName'] ?? ''})",
                              style: descriptionStyleDark,
                            ),
                            SizedBox(
                              height: getDynamicHeight(15),
                            ),
                            Text(
                              "Vehicle Name",
                              style: subTitleStyle,
                            ),
                            SizedBox(
                              height: getDynamicHeight(5),
                            ),
                            Text(
                              vehicleData['vehicle']['vehicleName'],
                              style: descriptionStyleDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                showStartBtn
                    ? GestureDetector(
                        onTap: () {
                          startReadingDialogue(
                            context,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.green.withOpacity(0.8),
                          ),
                          height: getDynamicHeight(45),
                          width: getDynamicWidth(80),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "START",
                                style: subTitleStyleLight1,
                              ),
                            ],
                          ),
                        ),
                      )
                    : showEndBtn
                        ? GestureDetector(
                            onTap: () {
                              endReadingDialogue(
                                context,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red.withOpacity(0.8),
                              ),
                              height: getDynamicHeight(45),
                              width: getDynamicWidth(80),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "STOP",
                                    style: subTitleStyleLight1,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  void startReadingDialogue(
    BuildContext context,
  ) {
    final _formKey = GlobalKey<FormState>();
    bool startVisible = true;
    String _updatedGangName;

    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.rotate(
            angle: math.radians(anim1.value * 360),
            child: Opacity(
              opacity: anim1.value,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    height: getDynamicHeight(250),
                    width: getDynamicWidth(400),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: getDynamicHeight(250),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
//                            crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Enter Start Readings",
                                    style: highlightDescription,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _startReadController,
                                          // onChanged: (value) =>
                                          //     _updatedGangName = value,
                                          autocorrect: true,
                                          obscureText: false,
                                          keyboardType: TextInputType.number,

                                          autofocus: true,
                                          cursorColor: backgroundColor,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: getDynamicTextSize(22),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          decoration: InputDecoration(
                                            counterStyle: TextStyle(
                                              // fontFamily: mainFontFamily,
                                              fontWeight: FontWeight.w600,
                                              fontSize: getDynamicTextSize(18),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            hintText: "ODO Reading",
                                            hintStyle: TextStyle(
                                              // fontFamily: mainFontFamily,
                                              fontWeight: FontWeight.w600,
                                              fontSize: getDynamicTextSize(22),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0.0),
                                            ),
                                          ),
                                          validator: (value) => value.isNotEmpty
                                              ? null
                                              : 'Please enter start Reading.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: getDynamicHeight(55),
                                    width: getDynamicWidth(150),
                                    child: GestureDetector(
                                      onTap: startVisible
                                          ? () async {
                                              if (_formKey.currentState
                                                      .validate() &&
                                                  _startReadController.text !=
                                                      null) {
                                                _formKey.currentState.save();
                                                setState(() {
                                                  startVisible = false;
                                                });

                                                try {
                                                  await Firestore.instance
                                                      .collection(
                                                          "vehicleEntries")
                                                      .document(
                                                          widget.documentId)
                                                      .updateData({
                                                    'startRead':
                                                        _startReadController
                                                            .text,
                                                    'startTime':
                                                        DateTime.now().toUtc(),
                                                  });
                                                  Navigator.pop(context);
                                                } catch (err) {
                                                  setState(() {
                                                    // isProcessing = false;
                                                    // error = err;
                                                  });
                                                } finally {
                                                  if (mounted) {
                                                    setState(() {
                                                      // isProcessing = false;
                                                    });
                                                  }
                                                }
                                              } else {
                                                setState(() {
                                                  //validated = true;
                                                });
                                              }
                                            }
                                          : () {
                                              print('In Process');
                                            },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: startVisible
                                                  ? Text(
                                                      "Start",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          //fontFamily: mainFontFamily,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              getDynamicTextSize(
                                                                  22),
                                                          decoration:
                                                              TextDecoration
                                                                  .none),
                                                    )
                                                  : CircularProgressIndicator(
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          // These values are based on trial & error method
                          alignment: Alignment(1.05, -1.05),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300));
  }

  void endReadingDialogue(
    BuildContext context,
  ) {
    final _formKey = GlobalKey<FormState>();
    bool stopVisible = true;
    String _updatedGangName;

    showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {},
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.4),
        barrierLabel: '',
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.rotate(
            angle: math.radians(anim1.value * 360),
            child: Opacity(
              opacity: anim1.value,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    height: getDynamicHeight(250),
                    width: getDynamicWidth(400),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: getDynamicHeight(250),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
//                            crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Enter End Readings",
                                    style: highlightDescription,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _endReadController,
                                          // onChanged: (value) =>
                                          //     _updatedGangName = value,
                                          autocorrect: true,
                                          obscureText: false,
                                          keyboardType: TextInputType.number,
                                          keyboardAppearance: Brightness.light,
                                          autofocus: true,
                                          cursorColor: backgroundColor,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: getDynamicTextSize(22),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          decoration: InputDecoration(
                                            counterStyle: TextStyle(
                                              // fontFamily: mainFontFamily,
                                              fontWeight: FontWeight.w600,
                                              fontSize: getDynamicTextSize(18),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                            hintText: "ODO Reading",
                                            hintStyle: TextStyle(
                                              // fontFamily: mainFontFamily,
                                              fontWeight: FontWeight.w600,
                                              fontSize: getDynamicTextSize(22),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0.0),
                                            ),
                                          ),
                                          validator: (value) => value.isNotEmpty
                                              ? null
                                              : 'Please enter end Reading.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: getDynamicHeight(55),
                                    width: getDynamicWidth(180),
                                    child: GestureDetector(
                                      onTap: stopVisible
                                          ? () async {
                                              if (_formKey.currentState
                                                      .validate() &&
                                                  _endReadController.text !=
                                                      null) {
                                                _formKey.currentState.save();
                                                setState(() {
                                                  stopVisible = false;
                                                });

                                                try {
                                                  await Firestore.instance
                                                      .collection(
                                                          "vehicleEntries")
                                                      .document(
                                                          widget.documentId)
                                                      .updateData({
                                                    'endRead':
                                                        _endReadController.text,
                                                    'endTime':
                                                        DateTime.now().toUtc(),
                                                  });
                                                  Navigator.pop(context);
                                                } catch (err) {
                                                  setState(() {
                                                    // isProcessing = false;
                                                    // error = err;
                                                  });
                                                } finally {
                                                  if (mounted) {
                                                    setState(() {
                                                      // isProcessing = false;
                                                    });
                                                  }
                                                }
                                              } else {
                                                setState(() {
                                                  //validated = true;
                                                });
                                              }
                                            }
                                          : () {
                                              print('In Process');
                                            },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: stopVisible
                                                  ? Text(
                                                      "Stop",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          //fontFamily: mainFontFamily,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              getDynamicWidth(
                                                                  22),
                                                          decoration:
                                                              TextDecoration
                                                                  .none),
                                                    )
                                                  : CircularProgressIndicator(
                                                      valueColor:
                                                          new AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          // These values are based on trial & error method
                          alignment: Alignment(1.05, -1.05),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300));
  }
}

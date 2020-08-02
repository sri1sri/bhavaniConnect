import 'dart:io';

import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_constants.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_variables/date_time_utils.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

class PrintPreviewGoods extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String selectedConstructionId;
  final String selectedConstructionSite;
  final String selectedDealerId;
  final String selectedDealer;
  final String vechileNumber;
  final String selectedConcreteTypeId;
  final String selectedConcreteType;

  const PrintPreviewGoods(
    this.startDate,
    this.endDate,
    this.selectedConstructionId,
    this.selectedConstructionSite,
    this.selectedDealerId,
    this.selectedDealer,
    this.vechileNumber,
    this.selectedConcreteTypeId,
    this.selectedConcreteType,
  );
  @override
  _PrintPreviewGoods createState() => _PrintPreviewGoods();
}

class _PrintPreviewGoods extends State<PrintPreviewGoods> {
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

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
    Size size = MediaQuery.of(context).size;
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
          rightActionBar: Icon(Icons.print, size: 25, color: Colors.white),
          rightAction: () {
            _generateCSVAndView(context);
          },
          primaryText: 'Print Preview',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          height: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: getDynamicHeight(20),
                ),
                Column(
                  children: [
                    Text(
                      "${DateTimeUtils.dayMonthFormat(widget.startDate)} to ${DateTimeUtils.dayMonthFormat(widget.endDate)}",
                      style: subTitleStyleDark1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.selectedConstructionSite ?? 'All'} | ${widget.selectedDealer ?? 'All'} | ${widget.selectedConcreteType ?? 'All'}",
                      // "ConstructionSite | Dealer | Category",
                      style: descriptionStyleDarkBlur1,
                    ),
                  ],
                ),
                SizedBox(
                  height: getDynamicHeight(40),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection(AppConstants.prod + "goodsApproval")
                        .where("construction_site.constructionId",
                            isEqualTo: widget.selectedConstructionId)
                        .where('dealer.dealerId',
                            isEqualTo: widget.selectedDealerId)
                        .where('concrete_type.concreteTypeId',
                            isEqualTo: widget.selectedConcreteTypeId)
                        .where('vehicleNumber', isEqualTo: widget.vechileNumber)
                        .where('status', isEqualTo: "Approved")
                        .where("added_on", isGreaterThan: widget.startDate)
                        .where("added_on", isLessThan: widget.endDate)
                        .orderBy('added_on', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      index = 0;
                      if (!snapshot.hasData) {
                        return Container(
                            child: Center(child: CircularProgressIndicator()),
                            width: size.width);
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error),
                        );
                      } else {
                        List<DocumentSnapshot> result = snapshot.data.documents;

                        return DataTable(
                          onSelectAll: (b) {},
                          sortAscending: true,
                          showCheckboxColumn: false,
                          dataRowHeight: getDynamicHeight(70),
                          columns: <DataColumn>[
                            DataColumn(
                                label: Text(
                              "S.No.",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Created On",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Created By",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Construction Site",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Category",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Dealer Name",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Vehicle Number",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Requested By",
                              style: subTitleStyle1,
                            )),
                            DataColumn(
                                label: Text(
                              "Approved By",
                              style: subTitleStyle1,
                            )),
                          ],
                          rows: result.map((item) {
                            index++;

                            ItemInfo itemRow = ItemInfo(
                              slNo: index.toString(),
                              date: DateTimeUtils.slashDateFormat(
                                  (item['added_on'] as Timestamp).toDate()),
                              createdBy:
                                  "${item['created_by']['name']} (${item['created_by']['role']})",
                              site:
                                  "${item['construction_site']['constructionSite']}",
                              category:
                                  "${item['concrete_type']['concreteTypeName']}",
                              dealerName: "${item['dealer']['dealerName']}",
                              vehicleName: "${item['vehicleNumber']}",
                              requestedBy:
                                  "${item['created_by']['name']} (${item['created_by']['role']})",
                              approvedBy:
                                  "${item['approved_by']['name']} (${item['approved_by']['role']})",
                            );
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    itemRow.slNo,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.date,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.createdBy,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.site,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.category,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.dealerName,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.vehicleName,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.requestedBy,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                                DataCell(
                                  Text(
                                    itemRow.approvedBy,
                                    style: descriptionStyleDark,
                                  ),
                                  showEditIcon: false,
                                  placeholder: false,
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      }
                    },
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

  Future<void> _generateCSVAndView(context) async {
    QuerySnapshot data = await Firestore.instance
        .collection(AppConstants.prod + "goodsApproval")
        .where("construction_site.constructionId",
            isEqualTo: widget.selectedConstructionId)
        .where('dealer.dealerId', isEqualTo: widget.selectedDealerId)
        .where('concrete_type.concreteTypeId',
            isEqualTo: widget.selectedConcreteTypeId)
        .where('vehicleNumber', isEqualTo: widget.vechileNumber)
        .where('status', isEqualTo: "Approved")
        .where("added_on", isGreaterThan: widget.startDate)
        .where("added_on", isLessThan: widget.endDate)
        .orderBy('added_on', descending: true)
        .getDocuments();
    int i = 0;
    List<List<String>> csvData = [
      // headers
      <String>[
        'S.No.',
        'Created On',
        'Created By',
        "Site",
        "Dealer Name",
        "Category",
        'Vehicle Number',
      ],
      // data
      ...data.documents.map((result) {
        i++;
        return [
          i.toString(),
          DateTimeUtils.slashDateFormat(
              (result['added_on'] as Timestamp).toDate()),
          "${result['created_by']['name']}  (${result['created_by']['role']})",
          result['construction_site']['constructionSite'],
          result['dealer']['dealerName'],
          result['concrete_type']['concreteTypeName'],
          result['vehicleNumber'],
        ];
      }),
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/filteredVehicles.csv';

    // create file
    final File file = File(path);
    // Save csv string using default configuration
    // , as field separator
    // " as text delimiter and
    // \r\n as eol.
    await file.writeAsString(csv);

    shareFile(path);
  }

  shareFile(String path) async {
    ShareExtend.share(path, "file");
  }
}

class ItemInfo {
  String slNo;
  String date;
  String site;
  String createdBy;
  String category;
  String dealerName;
  String vehicleName;
  String requestedBy;
  String approvedBy;

  ItemInfo({
    this.slNo,
    this.date,
    this.createdBy,
    this.site,
    this.category,
    this.dealerName,
    this.vehicleName,
    this.requestedBy,
    this.approvedBy,
  });
}

// var items = <ItemInfo>[
//   ItemInfo(
//       slNo: '1',
//       createdBy: "Vasanth (Manager)",
//       date: '29/Oct/2020',
//       site: 'Bhavani Vivan',
//       category: 'cevel work',
//       dealerName: 'vasanth agencies',
//       vehicleName: 'AP 26 TF 5643',
//       approvedBy: 'vasanth(manager)',
//       requestedBy: 'sri(security)')
// ];

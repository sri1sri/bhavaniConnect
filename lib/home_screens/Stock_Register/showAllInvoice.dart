import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/AddNewInvoice.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/Stock_Filter.dart';
import 'package:bhavaniconnect/home_screens/Stock_Register/detail_description.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ShowAllInvoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_ShowAllInvoice(),
    );
  }
}

class F_ShowAllInvoice extends StatefulWidget {
  @override
  _F_ShowAllInvoice createState() => _F_ShowAllInvoice();
}

class _F_ShowAllInvoice extends State<F_ShowAllInvoice> {
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
        child: CustomAppBarDark(
          leftActionBar: Icon(Icons.arrow_back_ios,size: 25,color: Colors.white,),
          leftAction: (){
            Navigator.pop(context,true);
          },
          rightActionBar: Icon(Icons.search,size: 25,color: Colors.white,),
          rightAction: (){
            GoToPage(
                context,
                StockFilter(
                ));
          },
          primaryText: 'Stock Register',
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
//                SingleChildScrollView(
//                  scrollDirection: Axis.horizontal,
//                  child: DataTable(
//                    onSelectAll: (b) {},
//                    sortAscending: true,
//                    showCheckboxColumn: false,
//                    dataRowHeight: 70.0,
//                    columns: <DataColumn>[
//                      DataColumn(label: Text("S.No.",style: subTitleStyle1,)),
////                      DataColumn(label: Text("Created On",style: subTitleStyle1,)),
////                      DataColumn(label: Text("Created By",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Purchased Date",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Site name",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Item Description",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Category",style: subTitleStyle1,)),
////                      DataColumn(label: Text("Uom",style: subTitleStyle1,)),
////                      DataColumn(label: Text("Dealer Name",style: subTitleStyle1,),),
//                      DataColumn(label: Text("Invoice No.",style: subTitleStyle1,),),
////                      DataColumn(label: Text("Received Quantity",style: subTitleStyle1,)),
////                      DataColumn(label: Text("Issued Quantity",style: subTitleStyle1,)),
////                      DataColumn(label: Text("Balance Quantity",style: subTitleStyle1,)),
////                      DataColumn(label: Text("Rate",style: subTitleStyle1,)),
////                      DataColumn(label: Text("Sub Total",style: subTitleStyle1,)),
////                      DataColumn(label: Text("GST Amount",style: subTitleStyle1,)),
//                      DataColumn(label: Text("Total Amount",style: subTitleStyle1,)),
//                      //DataColumn(label: Text("Remarks",style: subTitleStyle1,)),
//                    ],
//                    rows: items
//                        .map(
//                          (itemRow) => DataRow(onSelectChanged: (b) {GoToPage(
//                          context,
//                          DetailDescription());},
//                        cells: [
//                          DataCell(
//                            Text(itemRow.slNo,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
////                          DataCell(
////                            Text(itemRow.createdOn,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
////                          DataCell(
////                            Text(itemRow.createdBy,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
//                          DataCell(
//                            Text(itemRow.date,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.site,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.itemDescription,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
//                          DataCell(
//                            Text(itemRow.category,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
////                          DataCell(
////                            Text(itemRow.umo,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
////                          DataCell(
////                            Text(itemRow.supplierName,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
//                          DataCell(
//                            Text(itemRow.invoiceNo,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
////                          DataCell(
////                            Text(itemRow.receivedQty,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
////                          DataCell(
////                            Text(itemRow.issuedQty,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
////                          DataCell(
////                            Text(itemRow.balanceQty,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
////                          DataCell(
////                            Text(itemRow.rate,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
////                          DataCell(
////                            Text(itemRow.subTotal,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
////                          DataCell(
////                            Text(itemRow.gstAmount,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
//                          DataCell(
//                            Text(itemRow.totalAmt,style:descriptionStyleDark,),
//                            showEditIcon: false,
//                            placeholder: false,
//                          ),
////                          DataCell(
////                            Text(itemRow.remarks,style:descriptionStyleDark,),
////                            showEditIcon: false,
////                            placeholder: false,
////                          ),
//                        ],
//                      ),
//                    )
//                        .toList(),
//                  ),
//                ),
                StockRegister(size, context,"29 Oct 2020","Bhavani Vivan","28 Tons of TMT rods with steel blend.","Iron/Steel","MA6578HB","34,732.00"),
                StockRegister(size, context,"14 Nov 2020","Bhavani Aravindham","700 Plastic PVC Pipes with holders.","Plastics","F63GV374","65,344.00"),
                StockRegister(size, context,"29 Oct 2020","Bhavani Vivan","28 Tons of TMT rods with steel blend.","Iron/Steel","MA6578HB","34,732.00"),
                StockRegister(size, context,"14 Nov 2020","Bhavani Aravindham","700 Plastic PVC Pipes with holders.","Plastics","F63GV374","65,344.00"),
                SizedBox(height: 500,)
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () {
          GoToPage(
              context,
              AddInvoice(
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
  String createdOn;
  String createdBy;
  String date;
  String site;
  String itemDescription;
  String category;
  String umo;
  String supplierName;
  String invoiceNo;
  String receivedQty;
  String issuedQty;
  String balanceQty;
  String rate;
  String subTotal;
  String gstAmount;
  String totalAmt;
  String remarks;

  ItemInfo({
    this.slNo,
    this.date,
    this.createdOn,
    this.createdBy,
    this.site,
    this.itemDescription,
    this.category,
    this.umo,
    this.supplierName,
    this.invoiceNo,
    this.receivedQty,
    this.issuedQty,
    this.balanceQty,
    this.rate,
    this.subTotal,
    this.gstAmount,
    this.totalAmt,
    this.remarks,
  });
}

var items = <ItemInfo>[
  ItemInfo(
      slNo: '1',
      createdOn: '03/Nov/2020',
      createdBy: "Vasanth(Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      umo: 'Tons',
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate:'₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '2',
      createdOn: '03/Nov/2020',
      createdBy: "Vasanth(Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      umo: 'Tons',
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate:'₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '3',
      createdOn: '03/Nov/2020',
      createdBy: "Vasanth(Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      umo: 'Tons',
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate:'₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '4',
      createdOn: '03/Nov/2020',
      createdBy: "Vasanth(Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      umo: 'Tons',
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate:'₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'

  ),
  ItemInfo(
      slNo: '5',
      createdOn: '03/Nov/2020',
      createdBy: "Vasanth(Manager)",
      date: '29/Oct/2020',
      site: 'Bhavani Vivan',
      itemDescription: '28 Tons of TMT rods',
      category: 'Iron/Steel',
      umo: 'Tons',
      supplierName: 'Vasanth Steels',
      invoiceNo: '54569',
      receivedQty: '440',
      issuedQty: '340',
      balanceQty: '100',
      rate:'₹4732.00',
      subTotal: '₹4732.00',
      gstAmount: '₹32.00',
      totalAmt: '₹34,732.00',
      remarks: 'Transfer from store to cnstruction Site'

  ),
];

Widget StockRegister(Size size, BuildContext context,String date,String site,String description,String category,String invoiceNo,String total)
{
  return  GestureDetector(
    onTap: (){
      GoToPage(context,DetailDescription());
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
                    Text(
                      "Invoice No.:$invoiceNo",
                      style: descriptionStyleDarkBlur1,
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
                width: size.width * .35,
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
                  "₹ $total",
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


import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddInvoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddInvoice(),
    );
  }
}

class F_AddInvoice extends StatefulWidget {
  @override
  _F_AddInvoice createState() => _F_AddInvoice();
}

class _F_AddInvoice extends State<F_AddInvoice> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedDateInvoice = DateTime.now();
  var customFormat = DateFormat("dd MMMM yyyy 'at' HH:mm:ss 'UTC+5:30'");
  var customFormat2 = DateFormat("dd MMM yyyy");
  Future<Null> showPickerFrom(BuildContext context) async {
    final DateTime pickedFrom = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1930),
      lastDate: DateTime(2010),
    );
    if (pickedFrom != null){
      setState(() {
        print(customFormat.format(pickedFrom));
        selectedDate = pickedFrom;
      });
    }
  }
  Future<Null> showPickerTo(BuildContext context) async {
    final DateTime pickedTo = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1930),
      lastDate: DateTime(2010),
    );
    if (pickedTo != null){
      setState(() {
        print(customFormat.format(pickedTo));
        selectedDateInvoice = pickedTo;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _invoiceDateController = TextEditingController();
  final FocusNode _invoiceDateFocusNode = FocusNode();
  final TextEditingController _receivedQuantityController = TextEditingController();
  final FocusNode _receivedQuantityFocusNode = FocusNode();
  final TextEditingController _issuedQuantityController = TextEditingController();
  final FocusNode _issuedQuantityFocusNode = FocusNode();
  final TextEditingController _balanceQuantityController = TextEditingController();
  final FocusNode _balanceQuantityFocusNode = FocusNode();
  final TextEditingController _rateController = TextEditingController();
  final FocusNode _rateFocusNode = FocusNode();
  final TextEditingController _subTotalController = TextEditingController();
  final FocusNode _subTotalFocusNode = FocusNode();
  final TextEditingController _gstAmountController = TextEditingController();
  final FocusNode _gstAmountFocusNode = FocusNode();
  final TextEditingController _totalPriceController = TextEditingController();
  final FocusNode _totalPriceFocusNode = FocusNode();
  final TextEditingController _remarkController = TextEditingController();
  final FocusNode _remarkFocusNode = FocusNode();
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
          rightActionBar: Container(width: 10,),
          rightAction: (){
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Add Stock',
          tabBarWidget: null,
        ),
      ),
      body:ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0),
            topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Purchased Date",style: titleStyle,),
                          SizedBox(height: 20,),
                          GestureDetector(
                            onTap: () => showPickerFrom(context),
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.date_range,
                                    size: 30.0,
                                    color: backgroundColor,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                      '${customFormat2.format(selectedDate)}',
                                      style: highlightDescription
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Item Description",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 200,
                              mode: Mode.MENU,
                              items: ["Pvc plaster pipes", "8thread Tmt rods", "28 logs og wooden window"],
                              label: "Item Description",
                              onChanged: print,
                              selectedItem: "Choose Item Description",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Category",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 200,
                              mode: Mode.MENU,
                              items: ["Iron", "Steel", "Wood", "Cement"],
                              label: "Category",
                              onChanged: print,
                              selectedItem: "Choose Category",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Uom",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 200,
                              mode: Mode.MENU,
                              items: ["Mtr", "Tons", "Nos" ,"units"],
                              label: "Uom",
                              onChanged: print,
                              selectedItem: "Choose  UOM",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Dealer Name",style: titleStyle,),
                          SizedBox(height: 20,),
                          DropdownSearch(
                              showSelectedItem: true,
                              maxHeight: 200,
                              mode: Mode.MENU,
                              items: ["Vasanth steels", "Sri Cements", "Vamsi Bricks"],
                              label: "Dealer Name",
                              onChanged: print,
                              selectedItem: "Choose Dealer Name",
                              showSearchBox: true),
                          SizedBox(height: 20,),
                          Text("Invoice No.",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _invoiceDateController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'Invoice No. Quantity cant\'t be empty.',
                            focusNode: _invoiceDateFocusNode,
                            // onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.blur_linear,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Invoice No.',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Received Quantity",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _receivedQuantityController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'Received Quantity cant\'t be empty.',
                            focusNode: _receivedQuantityFocusNode,
                            // onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.add_shopping_cart,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Received Quantity',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Issued Quantity",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _issuedQuantityController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'Issued Quantity cant\'t be empty.',
                            focusNode: _issuedQuantityFocusNode,
                            //onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.shopping_cart,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Issued Quantity',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Balance Quantity",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _balanceQuantityController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'Balance Quantity cant\'t be empty.',
                            focusNode: _balanceQuantityFocusNode,
                            // onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.shopping_basket,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Balance Quantity',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Rate",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _rateController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'Rate cant\'t be empty.',
                            focusNode: _rateFocusNode,
                            //onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.monetization_on,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Item Rate',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Sub Total",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _subTotalController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'Sub Total cant\'t be empty.',
                            focusNode: _subTotalFocusNode,
                            // onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Sub Total',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("GST Amount",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _gstAmountController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'GST Amount cant\'t be empty.',
                            focusNode: _gstAmountFocusNode,
                            //onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.euro_symbol,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter GST Amount',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Total Amount (Including GST)",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _totalPriceController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'Total Amount (Including GST) cant\'t be empty.',
                            focusNode: _totalPriceFocusNode,
                            // onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.dashboard,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Total Amount',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.number,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),
                          Text("Remarks",style: titleStyle,),
                          SizedBox(height: 20,),
                          TextFormField(
                            controller: _remarkController,
                            //initialValue: _name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            validator: (value) => value.isNotEmpty ? null : 'Remarks cant\'t be empty.',
                            focusNode: _remarkFocusNode,
                            //onSaved: (value) => _name = value,
                            decoration: new InputDecoration(
                              prefixIcon: Icon(
                                Icons.list,
                                color: backgroundColor,
                              ),
                              labelText: 'Enter Remarks',
                              //fillColor: Colors.redAccent,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(5.0),
                                borderSide: new BorderSide(),
                              ),
                            ),

                            keyboardType: TextInputType.text,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(height: 20,),


                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 55,
                          width: 180,
                          child: GestureDetector(
                            onTap: () {
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => LoginPage(),),
//                      );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      "Create",
                                      style: activeSubTitleStyle,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

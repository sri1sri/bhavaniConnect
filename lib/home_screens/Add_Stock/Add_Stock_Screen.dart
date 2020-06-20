import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/enums.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/no_data_widget.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddStockScreen extends StatelessWidget {
  AddStockScreen({@required this.title, @required this.collectionName});
  String title;
  String collectionName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddStockScreen(
        title: title,
        collectionName: collectionName,
      ),
    );
  }
}

class F_AddStockScreen extends StatefulWidget {
  F_AddStockScreen({@required this.title, @required this.collectionName});
  String title;
  String collectionName;

  @override
  _F_AddStockScreen createState() => _F_AddStockScreen();
}

class _F_AddStockScreen extends State<F_AddStockScreen> {
  final TextEditingController _addStockController = TextEditingController();
  final FocusNode _addStockFocusNode = FocusNode();

  UserRoles userRole;

  bool isEnable = false;
  bool isEdit = false;
  String productDocumentId;

  @override
  void initState() {
    super.initState();
    getUserRoles();
  }

  getUserRoles() async {
    var prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("userRole");
    setState(() {
      userRole = userRoleValues[role];
    });
  }

  handleSubmit() async {
    if (isEdit == false) {
      await Firestore.instance
          .collection(widget.collectionName)
          .document()
          .setData({
        "name": _addStockController.text,
        "when": DateTime.now().toUtc(),
      });
    } else {
      if (productDocumentId != "") {
        await Firestore.instance
            .collection(widget.collectionName)
            .document(productDocumentId)
            .updateData({
          "name": _addStockController.text,
          "when": DateTime.now().toUtc(),
        });
        Toast.show("Edit successfully", context, duration: 3);
      }
      setState(() {
        productDocumentId = "";
        isEdit = false;
      });
    }
    setState(() {
      isEnable = false;
    });

    _addStockController.clear();
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
          primaryText: _title(),
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  userRole != null &&
                          (userRole == UserRoles.Admin ||
                              userRole == UserRoles.Manager ||
                              userRole == UserRoles.StoreManager ||
                              userRole == UserRoles.Supervisor)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "New ${widget.title} to be added",
                              style: titleStyle,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _addStockController,
                              //initialValue: _name,
                              textInputAction: TextInputAction.done,
                              obscureText: false,
                              validator: (value) => value.isNotEmpty
                                  ? null
                                  : '${widget.title} cant\'t be empty.',
                              focusNode: _addStockFocusNode,
                              //onSaved: (value) => _name = value,
                              decoration: new InputDecoration(
                                prefixIcon: Icon(
                                  Icons.category,
                                  color: backgroundColor,
                                ),
                                labelText: 'Enter ${widget.title} name',
                                //fillColor: Colors.redAccent,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  borderSide: new BorderSide(),
                                ),
                              ),
                              onChanged: (value) {
                                if (value.length < 1) {
                                  setState(() {
                                    isEnable = false;
                                  });
                                } else {
                                  setState(() {
                                    isEnable = true;
                                  });
                                }
                              },
                              keyboardType: TextInputType.text,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${widget.title}'s which you have",
                    style: titleStyle,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: buildListStockCard(),
                  ),
                  SizedBox(
                    height: 500,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: userRole != null &&
              (userRole == UserRoles.Admin ||
                  userRole == UserRoles.StoreManager ||
                  userRole == UserRoles.Manager ||
                  userRole == UserRoles.Supervisor)
          ? FloatingActionButton(
              onPressed: isEnable ? () => handleSubmit() : null,
              //   onPressed: () {
              //       GoToPage(context, AddInvoice());
              //   },
              child: Icon(Icons.add),
              backgroundColor:
                  isEnable ? backgroundColor : backgroundColor.withOpacity(.65),
            )
          : null,
    );
  }

  Widget buildListStockCard() {
    return StreamBuilder(
      stream: Firestore.instance.collection(widget.collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)));
        } else {
          // var itemData = snapshot.data.documents;
          if (snapshot.data.documents.length == 0) {
            return NoDataWidget();
          }
          return Column(
              children: snapshot.data.documents.map<Widget>((value) {
            DocumentSnapshot ds = value;
            return stockcard(ds["name"], context, ds.documentID, ds);
          }).toList());
        }
      },
    );
  }

  String _title() {
    switch (widget.title) {
      case 'Item':
        return 'Items';
        break;

      case 'Category':
        return 'Categories';
        break;
      case 'Sub Category':
        return 'Sub Categories';
        break;
      case 'Unit':
        return 'Units';
        break;
      case 'Dealer':
        return 'Dealers';
        break;

      case 'Role':
        return 'Roles';
        break;
      case 'Construction Site':
        return 'Construction Sites';
        break;
    }
  }

  Widget stockcard(
      String name, BuildContext context, String documentID, itemData) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      enabled: userRole != null &&
          (userRole == UserRoles.Admin ||
              userRole == UserRoles.Manager ||
              userRole == UserRoles.StoreManager ||
              userRole == UserRoles.Supervisor),
      child: Card(
        elevation: 1,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    name,
                    style: subTitleStyle,
                  ),
                )
              ],
            )),
      ),
      //    actions: <Widget>[
      //      IconSlideAction(
      //        caption: 'Archive',
      //        color: Colors.blue,
      //        icon: Icons.archive,
      //        //onTap: () => _showSnackBar('Archive'),
      //      ),
      //      IconSlideAction(
      //        caption: 'Share',
      //        color: Colors.indigo,
      //        icon: Icons.share,
      //        //onTap: () => _showSnackBar('Share'),
      //      ),
      //    ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black54,
          icon: Icons.mode_edit,
          onTap: () => handleEdit(documentID, context, itemData),
          //onTap: () => _showSnackBar('More'),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => handleDelete(documentID, context),
          //  onTap: () => _showSnackBar('Delete'),
        ),
      ],
    );
  }

  handleEdit(String documentID, context, itemData) async {
    setState(() {
      isEdit = true;
    });
    Firestore.instance
        .collection(widget.collectionName)
        .document(documentID)
        .get()
        .then((doc) {
      setState(() {
        productDocumentId = documentID;
        _addStockController.text = itemData["name"];
      });
    });
  }

  handleDelete(String documentID, context) async {
    Firestore.instance
        .collection(widget.collectionName)
        .document(documentID)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    Toast.show("Delete successfully", context, duration: 3);
  }
}

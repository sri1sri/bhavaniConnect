import 'package:bhavaniconnect/common_variables/app_colors.dart';
import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/custom_appbar_widget/custom_app_bar_2.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/Site_Activities/search_result_site_activities.dart';
import 'package:dropdown_search/dropdownSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

class SearchActivity extends StatefulWidget {
  final String currentUserId;
  final Function(String, String, String, String) onSearch;

  const SearchActivity({Key key, this.currentUserId, this.onSearch})
      : super(key: key);
  @override
  _SearchActivity createState() => _SearchActivity();
}

class _SearchActivity extends State<SearchActivity> {
  final _formKey = GlobalKey<FormState>();
  bool validated = false;

  String selectedConstructionSite;
  String selectedConstructionId;

  String selectedUnits;
  String selectedUnitsId;

  String selectedBlock;
  String selectedBlockId;

  String selectedCategory;
  String selectedCategoryId;

  String selectedSubCategory;
  String selectedSubCategoryId;

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
          rightActionBar: Container(
            width: 10,
          ),
          rightAction: () {
            print('right action bar is pressed in appbar');
          },
          primaryText: 'Search Activity',
          tabBarWidget: null,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.0), topLeft: Radius.circular(50.0)),
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
                    SizedBox(
                      height: getDynamicHeight(20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Construction Site",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height:getDynamicHeight(20),
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(
                                    AppConstants.prod + "constructionSite")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                List<String> items = snapshot.data.documents
                                    .map((e) => (e.documentID.toString()))
                                    .toList();
                                return DropdownSearch(
                                  showSelectedItem: true,
                                  maxHeight: 400,
                                  mode: Mode.MENU,
                                  items: items,
                                  dropdownItemBuilder:
                                      (context, value, isTrue) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents
                                          .firstWhere((element) =>
                                              element.documentID ==
                                              value)['name']
                                          .toString()),
                                      selected: isTrue,
                                      onTap: () {
                                        setState(() {
                                          selectedConstructionSite = snapshot
                                              .data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString();
                                          selectedConstructionId = value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  label: "Construction Site",
                                  onChanged: (value) {},
                                  selectedItem: selectedConstructionSite ??
                                      "All construction site selected",
                                  showSearchBox: true,
                                  validate: (value) {
                                    if (validated &&
                                        (selectedConstructionSite == null ||
                                            selectedConstructionSite.isEmpty)) {
                                      return "Construction Site cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Block",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(AppConstants.prod + "blocks")
                                .orderBy('name', descending: false)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                List<String> items = snapshot.data.documents
                                    .map((e) => (e.documentID.toString()))
                                    .toList();
                                return DropdownSearch(
                                  showSelectedItem: true,
                                  maxHeight: 400,
                                  mode: Mode.MENU,
                                  items: items,
                                  dropdownItemBuilder:
                                      (context, value, isTrue) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents
                                          .firstWhere((element) =>
                                              element.documentID ==
                                              value)['name']
                                          .toString()),
                                      selected: isTrue,
                                      onTap: () {
                                        setState(() {
                                          selectedBlock = snapshot
                                              .data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString();
                                          selectedBlockId = value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  label: "Block",
                                  onChanged: (value) {},
                                  selectedItem:
                                      selectedBlock ?? "All block selected",
                                  showSearchBox: true,
                                  validate: (value) {
                                    if (validated &&
                                        (selectedBlock == null ||
                                            selectedBlock.isEmpty)) {
                                      return "Block cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Category",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(AppConstants.prod + "category")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                List<String> items = snapshot.data.documents
                                    .map((e) => (e.documentID.toString()))
                                    .toList();
                                return DropdownSearch(
                                  showSelectedItem: true,
                                  maxHeight: 400,
                                  mode: Mode.MENU,
                                  items: items,
                                  dropdownItemBuilder:
                                      (context, value, isTrue) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents
                                          .firstWhere((element) =>
                                              element.documentID ==
                                              value)['name']
                                          .toString()),
                                      selected: isTrue,
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = snapshot
                                              .data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString();
                                          selectedCategoryId = value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  label: "Category",
                                  onChanged: (value) {},
                                  selectedItem: selectedCategory ??
                                      "All category selected",
                                  showSearchBox: true,
                                  validate: (value) {
                                    if (validated &&
                                        (selectedCategory == null ||
                                            selectedCategory.isEmpty)) {
                                      return "Category cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          Text(
                            "Sub Category",
                            style: titleStyle,
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection(AppConstants.prod + "subCategory")
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                List<String> items = snapshot.data.documents
                                    .map((e) => (e.documentID.toString()))
                                    .toList();
                                return DropdownSearch(
                                  showSelectedItem: true,
                                  maxHeight: 400,
                                  mode: Mode.MENU,
                                  items: items,
                                  dropdownItemBuilder:
                                      (context, value, isTrue) {
                                    return ListTile(
                                      title: Text(snapshot.data.documents
                                          .firstWhere((element) =>
                                              element.documentID ==
                                              value)['name']
                                          .toString()),
                                      selected: isTrue,
                                      onTap: () {
                                        setState(() {
                                          selectedSubCategory = snapshot
                                              .data.documents
                                              .firstWhere((element) =>
                                                  element.documentID ==
                                                  value)['name']
                                              .toString();
                                          selectedSubCategoryId = value;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  label: "Sub Category",
                                  onChanged: (value) {},
                                  selectedItem: selectedSubCategory ??
                                      "All subcategory selected",
                                  showSearchBox: true,
                                  validate: (value) {
                                    if (validated &&
                                        (selectedSubCategory == null ||
                                            selectedSubCategory.isEmpty)) {
                                      return "Sub Category cannot be empty";
                                    } else {
                                      return null;
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(
                            height: getDynamicHeight(20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getDynamicHeight(20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: getDynamicHeight(55),
                          width: getDynamicWidth(180),
                          child: GestureDetector(
                            onTap: () {
                              // widget.onSearch(
                              //     selectedConstructionId,
                              //     selectedBlockId,
                              //     selectedConstructionId,
                              //     selectedSubCategoryId);
                              // Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchResultActivities(
                                    currentUserId: widget.currentUserId,
                                    selectedConstructionId:
                                        selectedConstructionId,
                                    selectedConstructionSite:
                                        selectedConstructionSite,
                                    selectedBlock: selectedBlock,
                                    selectedBlockId: selectedBlockId,
                                    selectedCategory: selectedCategory,
                                    selectedCategoryId: selectedCategoryId,
                                    selectedSubCategory: selectedSubCategory,
                                    selectedSubCategoryId:
                                        selectedSubCategoryId,
                                  ),
                                ),
                              );
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
                                      "Search",
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
                    SizedBox(
                      height: getDynamicHeight(300),
                    ),
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

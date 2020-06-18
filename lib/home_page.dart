import 'package:bhavaniconnect/home_screens/dashboard.dart';
import 'package:bhavaniconnect/home_screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_widgets/navigationBar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.currentUserId}) : super(key: key);

  final String currentUserId;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    Widget child;
    //final database = Provider.of<Database>(context, listen: false);

    switch (currentIndex) {
      case 0:
        child = Dashboard(
          currentUserId: widget.currentUserId,
        );
        break;
      case 1:
        child = ProfilePage(widget.currentUserId);
        break;
    }
    return Scaffold(
      body: SizedBox.expand(
        child: child,
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Home'),
            activeColor: Color(0XFF1F4B6E),
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
            activeColor: Color(0XFF1F4B6E),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

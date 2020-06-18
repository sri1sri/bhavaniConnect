import 'package:bhavaniconnect/home_screens/dashboard.dart';
import 'package:bhavaniconnect/home_screens/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'common_widgets/navigationBar.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key key, this.currentUserId, this.goToNavigation = false, this.message})
      : super(key: key);

  final String currentUserId;
  final bool goToNavigation;
  final String message;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  bool goToNavigation;
  String notificaitonMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToNavigation = widget.goToNavigation;
    notificaitonMessage = widget.message;
  }

  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.goToNavigation != widget.goToNavigation) {
      setState(() {
        goToNavigation = widget.goToNavigation;
        notificaitonMessage = widget.message;
      });
    }
  }

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
          goToNavigation: goToNavigation,
          message: notificaitonMessage,
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

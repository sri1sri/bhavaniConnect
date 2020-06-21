import 'package:bhavaniconnect/common_variables/app_fonts.dart';
import 'package:bhavaniconnect/common_variables/app_functions.dart';
import 'package:bhavaniconnect/common_widgets/offline_widgets/offline_widget.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/login_screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({@required this.context});
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    SCREEN_SIZE = MediaQuery.of(context).size;
    return Container(
      child: F_OnboardingScreen(context: context,),
    );
  }
}

class F_OnboardingScreen extends StatefulWidget {
  F_OnboardingScreen({@required this.context});
  BuildContext context;

  @override
  _F_OnboardingScreenState createState() => _F_OnboardingScreenState();
}

class _F_OnboardingScreenState extends State<F_OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF1F4B6E) : Color(0xFF1F4B6E).withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }


  Widget ContSize(BuildContext context){
    if(MediaQuery.of(context).size <= const Size( 330,544))
    {
      return
        Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0), // changed padding from 25 to 0
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () => GoToPage(context, LoginPage()),
                      child: Text(
                        'Skip',
                        style: subTitleStyle,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 160,
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10,left: 10,right: 10),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'images/splash1.jpg',
                                  ),
                                  fit: BoxFit.fill,
                                  height: MediaQuery.of(context).size.height/3,
                                  width: MediaQuery.of(context).size.height/3,
                                ),
                              ),

                              SizedBox(
                                  height:50),
                              Text(
                                'Smart Constructions',
                                style: titleStyle,
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Introducing smart, secure and advanced techniques into construction for better living.',
                                style: descriptionStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'images/splash2.jpg',
                                  ),
                                  fit: BoxFit.fill,
                                  height: MediaQuery.of(context).size.height/3,
                                  width: MediaQuery.of(context).size.height/3,
                                ),
                              ),
                              SizedBox(
                                  height:50),
                              Text(
                                'At your fingertips',
                                style: titleStyle,
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Monitor and Manage all construction activities at your fingertips',
                                style: descriptionStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10,left: 10,right: 10),

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'images/splash3.jpg',
                                  ),
                                  fit: BoxFit.fill,
                                  height: MediaQuery.of(context).size.height/3,
                                  width: MediaQuery.of(context).size.height/3,
                                ),
                              ),
                              SizedBox(
                                  height:50),
                              Text(
                                'Secured Environment',
                                style: titleStyle,
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                'your safety is utmost important so feel safe with our advanced security',
                                style: descriptionStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ),
                  _currentPage != _numPages - 1
                      ? Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Next',
                              style: subTitleStyle,
                            ),
                            SizedBox(width: 10.0),
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF1F4B6E),
                              size: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : Text(''),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: _currentPage == _numPages - 1
            ? Container(
          height: 50.0,
          width: double.infinity,
          color: Color(0xFF1F4B6E),
          child: GestureDetector(
            onTap: () => GoToPage(context, LoginPage()),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Get started',
                  style: activeSubTitleStyle,
                ),
              ),
            ),
          ),
        )
            : Text(''),
      );
    }
    else
      {
      return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0), // changed padding from 25 to 0
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () => GoToPage(context, LoginPage()),
                      child: Text(
                        'Skip',
                        style: subTitleStyle,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 160,
                    child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10,left: 10,right: 10),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'images/splash1.jpg',
                                  ),
                                  fit: BoxFit.fill,
                                  height: MediaQuery.of(context).size.height/2,
                                  width: 500.0,
                                ),
                              ),

                              SizedBox(
                                  height:50),
                              Text(
                                'Smart Constructions',
                                style: titleStyle,
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Introducing smart, secure and advanced techniques into construction for better living.',
                                style: descriptionStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'images/splash2.jpg',
                                  ),
                                  fit: BoxFit.fill,
                                  height: MediaQuery.of(context).size.height / 2,
                                  width: 500.0,
                                ),
                              ),
                              SizedBox(
                                  height:50),
                              Text(
                                'At your fingertips',
                                style: titleStyle,
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Monitor and Manage all construction activities at your fingertips',
                                style: descriptionStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10,left: 10,right: 10),

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Image(
                                  image: AssetImage(
                                    'images/splash3.jpg',
                                  ),
                                  fit: BoxFit.fill,
                                  height: MediaQuery.of(context).size.height / 2,
                                  width: 500.0,
                                ),
                              ),
                              SizedBox(
                                  height:50),
                              Text(
                                'Secured Environment',
                                style: titleStyle,
                              ),
                              SizedBox(height: 2.0),
                              Text(
                                'your safety is utmost important so feel safe with our advanced security',
                                style: descriptionStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 10,
                    child: Row(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ),
                  _currentPage != _numPages - 1
                      ? Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Next',
                              style: subTitleStyle,
                            ),
                            SizedBox(width: 10.0),
                            Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF1F4B6E),
                              size: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : Text(''),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: _currentPage == _numPages - 1
            ? Container(
          height: 50.0,
          width: double.infinity,
          color: Color(0xFF1F4B6E),
          child: GestureDetector(
            onTap: () => GoToPage(context, LoginPage()),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Get started',
                  style: activeSubTitleStyle,
                ),
              ),
            ),
          ),
        )
            : Text(''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
//    double height = null;
//    double width = null;
//    print('available height==> $height');
//    print('available width 2==> $width');
//    if ((height > 533) || (width > 320)) {
//       height = MediaQuery.of(context).size.height;
//       width = MediaQuery.of(context).size.width;
//      // build small image.
//    } else {
//      height = MediaQuery.of(context).size.height/3;
//      width = MediaQuery.of(context).size.width/2;
//      // build big image.
//    }
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

  @override
  Widget _buildContent(BuildContext context) {
    return Scaffold(
      body: ContSize(context),
//      bottomSheet: _currentPage == _numPages - 1
//          ? Container(
//        height: 50.0,
//        width: double.infinity,
//        color: Color(0xFF1F4B6E),
//        child: GestureDetector(
//          onTap: () => GoToPage(context, LoginPage.create(widget.context)),
//          child: Center(
//            child: Padding(
//              padding: EdgeInsets.only(bottom: 10.0),
//              child: Text(
//                'Get started',
//                style: activeSubTitleStyle,
//              ),
//            ),
//          ),
//        ),
//      )
//          : Text(''),
    );
  }
}
import 'package:bhavaniconnect/home_screens/authentication_screen/splash_screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//void main() {
//  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//      .then((_) {
//    runApp(MyApp());
//  });
//}
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      debugShowCheckedModeBanner: false,
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: GettingStartedScreen(),
//      routes: {
//        LoginScreen.routeName: (ctx) => LoginScreen(),
//        SignupScreen.routeName: (ctx) => SignupScreen(),
//      },
//    );
//  }
//}

import 'landing_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
          title: 'Know It',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: OnboardingScreen()
        //routes: routes
      );
  }
}
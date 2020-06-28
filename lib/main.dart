import 'dart:async';
import 'dart:io';

import 'package:bhavaniconnect/geo/geo_util.dart';
import 'package:bhavaniconnect/home_page.dart';
import 'package:bhavaniconnect/home_screens/Goods_Approval/Display_Goods.dart';
import 'package:bhavaniconnect/home_screens/Vehicle_Entry/vehicle_list_details.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/login_screens/phone_number_page.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/registrtion_screens/sign_up_page.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/splash_screens/onboarding_screen.dart';
import 'package:bhavaniconnect/home_screens/notification_screen.dart';
import 'package:bhavaniconnect/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bhavaniconnect/common_variables/app_constants.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationState authenticationState;

  StreamSubscription profileChangesSubscription;

  SignupState state;

  // Replace with server token from firebase console settings.
  final String serverToken = '<Server-Token>';
  String deviceToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _getToken() {
    _firebaseMessaging.getToken().then((token) {
      deviceToken = token;
      print("Device Token: $deviceToken");
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _setMessage(context, message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _setMessage(context, message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _setMessage(context, message);
      },
      onBackgroundMessage:
          Platform.isAndroid ? Fcm.myBackgroundMessageHandler : null,
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  _setMessage(BuildContext context, Map<String, dynamic> message) {
    if (!Platform.isIOS) {
      final notification = message['notification'];
      final data = message['data'];
      String title = notification['title'];

      final String body = notification['body'];

      String mMessage = data != null ? data['message'] : message['message'];
      if (mMessage != "vehicle" || mMessage != "goods") {
        Provider.of<NotificationModel>(context).increment(
          listen: false,
        );
      }
      if (title == null && mMessage != null) {
        navigatorKey.currentState.pushNamed("/" + mMessage);
      } else {
        showNotificaitonDialog(context, title, mMessage);
      }
    } else {
      String mMessage = message['message'];
      var apsAlert = message['aps']['alert'];

      String title = apsAlert['title'];

      final String body = apsAlert['body'];

      if (title == null && mMessage != null) {
        print(mMessage);
        Provider.of<NotificationModel>(context)
            .removeNotifications(listen: false);
        navigatorKey.currentState.pushNamed("/" + mMessage);
      } else {
        showNotificaitonDialog(context, title, mMessage);
      }
    }
  }

  showNotificaitonDialog(context, String title, mMessage) {
    showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (ctx) => Center(
              child: Container(
                height: 220.0,
                width: double.infinity,
                child: AlertDialog(
                  content: Column(
                    children: <Widget>[
                      Text(
                        title ?? "Notificaiton",
                      ),
                      SizedBox(height: 10.0),
                      Text(mMessage == "goods"
                          ? "Navigate to Vehicle Entries"
                          : mMessage == "vehicle"
                              ? "Navigate to Goods Approval"
                              : "Navigate to Notifications")
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('Yes Sure'),
                      onPressed: () async {
                        Provider.of<NotificationModel>(context)
                            .removeNotifications();
                        navigatorKey.currentState.pop();
                        if (mMessage == "goods") {
                          navigatorKey.currentState.push(MaterialPageRoute(
                              builder: (BuildContext context) => GoodsScreen(
                                    currentUserId: authenticationState.user.uid,
                                  )));
                        } else if (mMessage == "vehicle") {
                          navigatorKey.currentState.push(MaterialPageRoute(
                              builder: (BuildContext context) => DaySelection(
                                  currentUserId:
                                      authenticationState.user.uid)));
                        } else {
                          navigatorKey.currentState.push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NotificationPage(
                                      currentUserId:
                                          authenticationState.user.uid)));
                        }
                      },
                    ),
                    FlatButton(
                      child: const Text("No Don't"),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    _configureFirebaseListeners();
    FirebaseAuth.instance.onAuthStateChanged.listen((fireuser) {
      if (fireuser == null) {
        profileChangesSubscription?.cancel();

        setState(() {
          authenticationState = AuthenticationState(SignupState.guest, null);
        });
        return;
      }

      // if user has changed we don't want to be listening to profile snapshots from old user
      profileChangesSubscription?.cancel();

      profileChangesSubscription = Firestore.instance
          .collection(AppConstants.prod + 'userData')
          .document(fireuser.uid)
          .snapshots()
          .listen((snapshot) {
        if (!snapshot.exists) {
          setState(() {
            authenticationState =
                AuthenticationState(SignupState.guest, fireuser);
          });
          return;
        }

        var profile = snapshot.data;

        setUserParams(profile);

        print(profile);
        if (profile['name'] == null) {
          setState(() {
            authenticationState =
                AuthenticationState(SignupState.needsSignUp, fireuser);
          });
          return;
        }

        if (profile['construction_site'] == null) {
          setState(() {
            authenticationState =
                AuthenticationState(SignupState.needsFirstname, fireuser);
          });

          return;
        }

        if (profile['role'] == null) {
          setState(() {
            authenticationState =
                AuthenticationState(SignupState.needsAvatar, fireuser);
          });
          return;
        }

        setState(() {
          authenticationState =
              AuthenticationState(SignupState.complete, fireuser);
        });
      });
    });
  }

  setUserParams(Map profile) async {
    var prefs = await SharedPreferences.getInstance();
    if (profile != null && profile['role'] != null) {
      prefs.setString("userRole", profile['role']);
    }
    if (profile != null && profile['name'] != null) {
      prefs.setString("userName", profile['name']);
    }
    if (profile != null && profile['construction_site'] != null) {
      prefs.setString(
          "constructionId", profile['construction_site']['constructionId']);
      prefs.setString(
          "constructionSite", profile['construction_site']['constructionSite']);
      DocumentSnapshot siteDocument = await Firestore.instance
          .collection(AppConstants.prod + 'constructionSite')
          .document(profile['construction_site']['constructionId'])
          .get();
      LatLng location = GeoUtil.locationToPoint(siteDocument);

      prefs.setDouble("siteLatitude", location.latitude);
      prefs.setDouble("siteLongitude", location.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotificationModel()),
      ],
      child: MaterialApp(
          title: 'B-Connect',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: _handleCurrentScreen(),
          routes: <String, WidgetBuilder>{
            "/goods": (BuildContext context) =>
                GoodsScreen(currentUserId: authenticationState.user.uid),
            "/vehicle": (BuildContext context) =>
                new DaySelection(currentUserId: authenticationState.user.uid),
            "/" + AppConstants.prod + "goodsApproval": (BuildContext context) =>
                new NotificationPage(
                    currentUserId: authenticationState.user.uid),
            "/" + AppConstants.prod + "vehicleEntries":
                (BuildContext context) => new NotificationPage(
                    currentUserId: authenticationState.user.uid),
          },
          navigatorKey: navigatorKey),
    );
  }

  Widget _handleCurrentScreen() {
    if (authenticationState == null) {
      return OnboardingScreen(
        context: context,
      );
    }

    switch (state ?? authenticationState.signupState) {
      case SignupState.complete:
        return HomePage(
          currentUserId: authenticationState.user.uid,
        );

      case SignupState.needsSignUp:
        return SignUpPage(
          user: authenticationState.user,
        );

      case SignupState.needsFirstname:
        return SignUpPage(
          user: authenticationState.user,
        );

      case SignupState.needsAvatar:
        return SignUpPage(
          user: authenticationState.user,
        );

      case SignupState.guest:
        return PhoneNumberPage();
    }

    return PhoneNumberPage();
  }
}

enum SignupState { guest, needsSignUp, needsFirstname, needsAvatar, complete }

class AuthenticationState {
  SignupState signupState;
  FirebaseUser user;

  AuthenticationState(this.signupState, this.user);
}

class Message {
  String title;
  String body;
  String message;
  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}

class Fcm {
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    print('messsage');
    print(message);
    print(message);
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }
}

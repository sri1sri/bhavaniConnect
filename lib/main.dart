import 'dart:async';

import 'package:bhavaniconnect/home_page.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/login_screens/phone_number_page.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/registrtion_screens/sign_up_page.dart';
import 'package:bhavaniconnect/home_screens/authentication_screen/splash_screens/onboarding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
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
          .collection('userData')
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

        setUserRole(profile['role']);

        print(profile);
        if (profile['name'] == null) {
          setState(() {
            authenticationState =
                AuthenticationState(SignupState.needsSignUp, fireuser);
          });
          return;
        }

        if (profile['date_of_birth'] == null ||
            profile['date_of_birth'] == "") {
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

  setUserRole(String role) async {
    var prefs = await SharedPreferences.getInstance();
    if (role != null) {
      prefs.setString("userRole", role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Know It',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: _handleCurrentScreen(),
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
        return HomePage(currentUserId: authenticationState.user.uid);

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

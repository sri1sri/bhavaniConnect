//import 'dart:async';
//import 'package:bhavani_connect/firebase/auth.dart';
//import 'package:flutter/foundation.dart';
//
//class LoginPageManager {
//
//  LoginPageManager({@required this.auth, @required this.isLoading});
//  final AuthBase auth;
//  final ValueNotifier<bool> isLoading;
//
//  Future<User> _signIn(Future<User> Function() signInMethod) async{
//    try {
//      isLoading.value = true;
//      return await signInMethod();
//    } catch (e) {
//      isLoading.value = false;
//      rethrow;
//    }
//  }
//  Future<User> signInAnonymously() async => await _signIn(auth.signInAnonymously);
//}
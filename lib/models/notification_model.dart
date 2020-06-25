import 'package:flutter/material.dart';

class NotificationModel with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void removeNotifications() {
    _count = 0;
    notifyListeners();
  }
}

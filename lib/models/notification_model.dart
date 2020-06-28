import 'package:flutter/material.dart';

class NotificationModel with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment({bool listen = true}) {
    _count++;
    if (listen == true) {
      notifyListeners();
    }
  }

  void removeNotifications({bool listen = true}) {
    _count = 0;
    if (listen == true) {
      notifyListeners();
    }
  }
}

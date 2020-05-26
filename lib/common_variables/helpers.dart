import 'package:flutter/material.dart';

class HasValue {
  static bool hasValue(obj) {
    if (obj == null) {
      return false;
    }

    if (obj is String) {
      return obj.length > 0;
    }

    if (obj is int || obj is double) {
      return obj.toString().length > 0;
    }

    if (obj is List) {
      return obj.length > 0;
    }

    return true;
  }
}

class RedError extends StatelessWidget {
  final dynamic error;

  RedError(this.error);

  @override
  Widget build(BuildContext context) {
    String message = "";
    try {
      message = error.message;
    } catch (NoSuchMethod) {
      message = "$error";
    }

    return Text(message, style: TextStyle(color: Colors.red));
  }
}

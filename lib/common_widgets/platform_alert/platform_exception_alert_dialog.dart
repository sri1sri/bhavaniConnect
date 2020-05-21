
import 'package:bhavaniconnect/common_widgets/platform_alert/platform_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog{

  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
  }) : super(
    title : title,
    content: _message(exception),
    defaultActionText: 'Ok',
  );

  static String _message(PlatformException exception){
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {

    'ERROR_WEAK_PASSWORD':'Password is too weak, Please try with stong password.',
    'ERROR_INVALID_EMAIL':'The E-mail you entered is invalid, Please enter valid E-mail.',
    'ERROR_EMAIL_ALREADY_IN_USE':'The E-mail you entered is already registered, Please try to register with new E-mail.',
    'ERROR_WRONG_PASSWORD' : 'The password you entered is wrong. Please enter correct password.',
    'ERROR_USER_NOT_FOUND':'User has not found, Please enter correct E-mail and Password.',
    'ERROR_USER_DISABLED':'This user account has been disabled, Please contact the customer care.',
    'ERROR_TOO_MANY_REQUESTS':'There are too many requests, Please try after sometime.',
    'ERROR_OPERATION_NOT_ALLOWED':'This can\'t be done. Please contact customer care.',
  };
}
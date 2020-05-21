import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

void GoToPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) => page,
    ),
  );
}

String EMPLOYEE_ID;
String DEVICE_TOKEN;
String EMPLOYEE_PNO='';
ImageSource IMAGE_SOURCE = ImageSource.gallery;


String getDateTime(int timestamp) {
  var format = new DateFormat('dd MMM yyyy, hh:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return format.format(date);
}

String getDate(int timestamp) {
  var format = new DateFormat('dd MMMM, yyyy');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return format.format(date);
}

String getTime(int timestamp) {
  var format = new DateFormat('hh:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  return timestamp == 0 ? '--' : format.format(date);


}


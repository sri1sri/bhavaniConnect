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

Size SCREEN_SIZE;
double IPHONE_11_PRO_MAX_HEIGHT = 896;
double IPHONE_11_PRO_MAX_Width = 414;

double getDynamicHeight( double height,){
  double actualHeightPercentage = height/IPHONE_11_PRO_MAX_HEIGHT;
  double dynamicHeight = actualHeightPercentage * SCREEN_SIZE.height;

  return dynamicHeight;
}

double getDynamicWidth( double width){
  double actualHeightPercentage = width/IPHONE_11_PRO_MAX_Width;
  double dynamicWidth = actualHeightPercentage * SCREEN_SIZE.width;

  return dynamicWidth;
}

double getDynamicTextSize(double size){
  double actualSizePercentage = size/IPHONE_11_PRO_MAX_Width;
  double dynamicTextSize = actualSizePercentage * SCREEN_SIZE.width;

  return dynamicTextSize;
}


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

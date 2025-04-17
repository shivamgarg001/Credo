// flushbar_helper.dart
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Flushbar? flushbar;
// Function for showing success Flushbar (green color)
void showSuccessFlushbar(BuildContext context, String type) async{
  Flushbar(
    message: type,
    backgroundColor: Colors.green,  // Green color for success
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.check_circle,
      color: Colors.white,
    ),
    flushbarPosition: FlushbarPosition.BOTTOM,
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: Duration(milliseconds: 300),
  ).show(context);
}

// Function for showing error Flushbar (red color)
void showErrorFlushbar(BuildContext context, String type) async{
  Flushbar(
    message: type,
    backgroundColor: Colors.red,  // Red color for error
    duration: Duration(seconds: 3),
    icon: Icon(
      Icons.error,
      color: Colors.white,
    ),
    flushbarPosition: FlushbarPosition.BOTTOM,
    margin: EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: Duration(milliseconds: 300),
  ).show(context);
}

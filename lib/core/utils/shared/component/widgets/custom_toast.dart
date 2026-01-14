import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void showCustomToast({required String message, Duration? duration}) {
    Fluttertoast.showToast(
      msg: message!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static void showCustomErrorToast(
      {required String message, Color? color, Duration? duration}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
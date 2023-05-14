import 'package:flutter/material.dart';

class EssentialWidgets {
  static void showSnackBar(BuildContext context, String content) {
    final snackBar = SnackBar(
      content: Text(content),
      backgroundColor: Colors.brown,
      behavior: SnackBarBehavior.floating,
      // width: 200,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // void showSnackBar(BuildContext context) {
  //   final snackBar = SnackBar(
  //     content: Text('Hi, Flutter developers'),
  //     backgroundColor: Colors.teal,
  //     behavior: SnackBarBehavior.floating,
  //     margin: EdgeInsets.all(50),
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }
}

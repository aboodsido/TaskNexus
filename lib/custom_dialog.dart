import 'package:flutter/material.dart';

class CustomDialog {
  static void showSnackBar(BuildContext context, String text, Color color) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: color.withOpacity(0.8),
      behavior: SnackBarBehavior.floating,
      elevation: 20,
      padding: const EdgeInsets.all(10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

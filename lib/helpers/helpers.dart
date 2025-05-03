import 'package:flutter/material.dart';

abstract class Helpers {

  // Place this helper method outside the build method, in the same widget class or globally.
static showSuccessSnackBar(BuildContext context, {required String message, required bool isSuccess}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: Colors.black)),
      duration: Duration(seconds: 2),
      backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
    ),
  );
}
}

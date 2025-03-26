import 'package:flutter/material.dart';

class CustomMessageNotifier {
  static showSnackBar(BuildContext context, String msg,
      {bool? onSuccess, bool? onError}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: onSuccess != null
          ? Colors.green
          : onError != null
              ? Colors.red
              : const Color.fromARGB(255, 42, 42, 56),
      content: Text(msg),
      showCloseIcon: true,
      duration: const Duration(milliseconds: 1500),
    ));
  }
}

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class Notify {
  Notify(String Message, String title, BuildContext context, ContentType type) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
              title: title, message: Message, contentType: type)),
    );
  }
}

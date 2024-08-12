import 'package:flutter/material.dart';

class ConfirmationDialog {
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
  }) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevents dialog dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff66923b),
              ),
              child: Text(confirmText, style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

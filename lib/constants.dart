import 'package:flutter/material.dart';

class Constants {
  Color primaryColor = const Color.fromRGBO(255, 0, 0, 1);
  // Color primaryColor = Colors.amber;

  Color cartItemColor = const Color.fromRGBO(255, 114, 79, 1);

  Color secondaryColor = const Color.fromRGBO(95, 95, 95, 1);

  Color backGroundColor = const Color.fromRGBO(250, 250, 250, 1);

  static bool kioskItmesLoaded = false;

  static bool cartLoaded = false;

  static bool kioskUsersLoaded = false;

  static bool terminalInilized = false;
  bool convertStringToBool(String stringValue) {
    if (stringValue.toLowerCase() == "true") {
      return true;
    } else {
      return false;
    }
  }

  Color hexToColor(String hexColor) {
    // Remove the '#' symbol if present
    if (hexColor.startsWith('#')) {
      hexColor = hexColor.substring(1);
    }
    return Color(int.parse(hexColor, radix: 16) + 0xFF000000);
  }

  void showAlert(
      {required BuildContext context,
      required String title,
      required String content,
      required String button1Text,
      required String button2Text,
      required Function() onTap1,
      required Function() onTap2}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: onTap1,
            child: Text(button1Text),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: onTap2,
            child: Text(button2Text),
          ),
        ],
      ),
    );
  }

  void showDialogBox(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
  }

  void showDialogBoxToConfirm(
      {required BuildContext context,
      required Function(bool response) responseFunction,
      required String title,
      required String content,
      required String confirmText,
      required String cancelText}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              responseFunction(false);
              Navigator.of(context).pop();
            },
            child: Text(cancelText),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              responseFunction(true);
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

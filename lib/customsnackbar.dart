import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType { success, error, warning, info }

void showCustomSnackbar({
  required String title,
  required String message,
  SnackbarType type = SnackbarType.info,
  Duration duration = const Duration(seconds: 3),
  SnackPosition position = SnackPosition.BOTTOM,
  TextButton? mainButton, // changed from Widget? to TextButton?
}) {
  // Auto-set color & icon based on type
  late Color backgroundColor;
  late IconData iconData;

  switch (type) {
    case SnackbarType.success:
      backgroundColor = Colors.green;
      iconData = Icons.check_circle;
      break;
    case SnackbarType.error:
      backgroundColor = Colors.red;
      iconData = Icons.error_outline;
      break;
    case SnackbarType.warning:
      backgroundColor = Colors.yellowAccent.shade700;
      iconData = Icons.warning_amber_rounded;
      break;
    case SnackbarType.info:
    default:
      backgroundColor = Colors.blue;
      iconData = Icons.info_outline;
      break;
  }

  Get.snackbar(
    title,
    message,
    snackPosition: position,
    backgroundColor: backgroundColor,
    colorText: Colors.black,
    icon: Icon(
      iconData,
      color: Colors.black,
    ),
    titleText: Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
    mainButton: mainButton,
    duration: duration,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeInOut,
  );
}

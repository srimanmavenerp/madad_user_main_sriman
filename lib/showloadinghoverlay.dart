import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customOrangeSnackBar(
  String message,
  String? title, {
  bool showDefaultSnackBar = false,
}) {
  Get.snackbar(
    title ?? 'Invalid Time',
    message,
    backgroundColor: Colors.orange.withOpacity(0.95),
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    borderRadius: 12,
    duration: const Duration(seconds: 3),
    icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
    snackStyle: SnackStyle.FLOATING,
  );
}

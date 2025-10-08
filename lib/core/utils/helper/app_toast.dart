import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class AppToast {
  static void _show(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.black87,
    IconData? icon,
    Duration duration = const Duration(seconds: 2),
  }) {
    Flushbar(
      message: message,
      backgroundColor: backgroundColor,
      duration: duration,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(16),
      flushbarPosition: FlushbarPosition.BOTTOM,
      icon: icon != null ? Icon(icon, color: Colors.white) : null,
    ).show(context);
  }

  static void success(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
    );
  }

  static void error(BuildContext context, String message) {
    _show(context, message, backgroundColor: Colors.red, icon: Icons.error);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, backgroundColor: Colors.blueGrey, icon: Icons.info);
  }
}

import 'package:flutter/material.dart';

/// UI helpers for the snackbars used across the app.
///
/// Each helper replaces any currently shown snackbar, so at most one is
/// visible at a time (the previous implementation kept a hidden snackbar
/// around and hid the new one immediately in a `finally` block).
void showSnackBar(
  BuildContext context,
  String message, {
  SnackBarAction? action,
  Color? backgroundColor,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      action: action,
      backgroundColor: backgroundColor,
    ),
  );
}

void showLoadingSnackBar(BuildContext context) {
  showSnackBar(context, 'Loading...');
}

void showSuccessSnackBar(BuildContext context, String message) {
  showSnackBar(
    context,
    message,
    backgroundColor: Colors.green.shade700,
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  showSnackBar(
    context,
    message,
    backgroundColor: Colors.red.shade700,
  );
}

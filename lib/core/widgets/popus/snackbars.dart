import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 10),
    content: Text(message),
  ));
}

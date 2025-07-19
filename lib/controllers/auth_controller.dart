import 'package:flutter/material.dart';

class AuthController {
  void showError(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
import 'package:flutter/material.dart';
import '../views/welcome_view.dart';

import 'package:flutter/material.dart';
import '../views/welcome_view.dart';

class ProfileController extends ChangeNotifier {
  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void logout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out!')),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomeView()),
        (route) => false,
      );
    });
  }
}

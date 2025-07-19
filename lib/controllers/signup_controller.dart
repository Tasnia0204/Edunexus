import 'package:flutter/material.dart';
import '../views/login_view.dart';

class SignupController {
  void signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) {
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError('Please fill all fields.', context);
    } else if (password != confirmPassword) {
      _showError('Passwords do not match.', context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginView()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created')),
      );
    }
  }

  void _showError(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

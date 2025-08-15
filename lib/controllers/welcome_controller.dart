import 'package:flutter/material.dart';

class WelcomeController {
  void onSignIn(context) {
    Navigator.pushNamed(context, '/signin');
  }

  void onSignUp(context) {
    Navigator.pushNamed(context, '/signup');
  }

  void onAboutUs(context) {
    Navigator.pushNamed(context, '/about');
  }
}

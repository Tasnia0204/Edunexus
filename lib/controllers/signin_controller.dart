import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String error = '';

  Future<bool> signIn(BuildContext context) async {
    error = '';
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Sign in failed';
      return false;
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    if (emailController.text.trim().isEmpty) {
      error = 'Enter your email to reset password.';
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      error = 'Password reset email sent.';
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Failed to send reset email.';
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

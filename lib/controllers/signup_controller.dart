import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? department;
  int? admittedYear;
  String error = '';

  List<String> departments = [
    'CSE', 'CS', 'BBA', 'LAW', 'Microbiology', 'Pharmacy', 'EEE', 'Civil', 'Textile', 'English', 'Economics', 'Other'
  ];

  List<int> getAdmittedYears() {
    final now = DateTime.now().year;
    return List.generate(8, (i) => now - i);
  }

  Future<bool> signUp(BuildContext context) async {
    error = '';
    if (passwordController.text != confirmPasswordController.text) {
      error = 'Passwords do not match.';
      return false;
    }
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'department': department,
        'admittedYear': admittedYear,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Sign up failed';
      return false;
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}

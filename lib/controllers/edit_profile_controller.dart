import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
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

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    final data = doc.data();
    if (data != null) {
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
      department = data['department'];
      admittedYear = data['admittedYear'];
      bioController.text = data['bio'] ?? '';
    }
  }

  Future<bool> updateProfile() async {
    error = '';
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        error = 'User not found.';
        return false;
      }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': nameController.text.trim(),
        'department': department,
        'admittedYear': admittedYear,
        'bio': bioController.text.trim(),
      });
      return true;
    } catch (e) {
      error = 'Failed to update profile.';
      return false;
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController {
  Future<Map<String, dynamic>?> getUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return doc.data();
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupController {
  Future<List<Map<String, dynamic>>> getUserGroups() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    final snapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('members', arrayContains: user.uid)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}

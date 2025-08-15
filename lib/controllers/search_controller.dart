import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchController {
  Future<List<Map<String, dynamic>>> searchUsers({required String query, required bool byName}) async {
    if (query.trim().isEmpty) return [];
    final usersRef = FirebaseFirestore.instance.collection('users');
    QuerySnapshot snapshot;
    if (byName) {
      snapshot = await usersRef.where('name', isGreaterThanOrEqualTo: query).where('name', isLessThanOrEqualTo: '$query\uf8ff').get();
    } else {
      snapshot = await usersRef.where('department', isEqualTo: query).get();
    }
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  List<String> departments = [
    'CSE', 'CS', 'BBA', 'LAW', 'Microbiology', 'Pharmacy', 'EEE', 'Civil', 'Textile', 'English', 'Economics', 'Other'
  ];
}

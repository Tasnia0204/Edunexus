import 'package:cloud_firestore/cloud_firestore.dart';

class NoteController {
  Stream<QuerySnapshot> getNotesStream() {
    return FirebaseFirestore.instance.collection('notes').orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> uploadNote({
    required String noteName,
    required String courseName,
    required String facultyName,
    required String driveLink,
  }) async {
    await FirebaseFirestore.instance.collection('notes').add({
      'noteName': noteName,
      'courseName': courseName,
      'facultyName': facultyName,
      'driveLink': driveLink,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

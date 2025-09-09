import 'package:cloud_firestore/cloud_firestore.dart';

class BlogController {
  Stream<QuerySnapshot> getBlogsStream() {
    return FirebaseFirestore.instance.collection('blogs').orderBy('timestamp', descending: true).snapshots();
  }

  Future<QuerySnapshot> getBlogRatings(String blogId) {
    return FirebaseFirestore.instance.collection('blogs').doc(blogId).collection('ratings').get();
  }
}

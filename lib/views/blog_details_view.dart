import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_colors.dart';

class BlogDetailsView extends StatefulWidget {
  final String blogId;
  const BlogDetailsView({super.key, required this.blogId});

  @override
  State<BlogDetailsView> createState() => _BlogDetailsViewState();
}

class _BlogDetailsViewState extends State<BlogDetailsView> {
  final _commentController = TextEditingController();
  int? _userRating;
  bool _loading = true;
  Map<String, dynamic>? _blog;
  List<Map<String, dynamic>> _comments = [];
  double _avgRating = 0;
  int _ratingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadBlog();
    _loadCommentsAndRatings();
  }

  Future<void> _loadBlog() async {
    final doc = await FirebaseFirestore.instance.collection('blogs').doc(widget.blogId).get();
    setState(() {
      _blog = doc.data();
      _loading = false;
    });
  }

  Future<void> _loadCommentsAndRatings() async {
    final commentsSnap = await FirebaseFirestore.instance.collection('blogs').doc(widget.blogId).collection('comments').orderBy('timestamp').get();
    final ratingsSnap = await FirebaseFirestore.instance.collection('blogs').doc(widget.blogId).collection('ratings').get();
    final user = await FirebaseFirestore.instance.collection('blogs').doc(widget.blogId).collection('ratings')
      .where('userId', isEqualTo: FirebaseFirestore.instance.app.options.projectId)
      .get();
    int? userRating;
    if (user.docs.isNotEmpty) {
      userRating = (user.docs.first.data()['rating'] as num?)?.toInt();
    }
    setState(() {
  _comments = commentsSnap.docs.map((d) => d.data()).toList();
      _ratingCount = ratingsSnap.docs.length;
      if (_ratingCount > 0) {
        _avgRating = ratingsSnap.docs.map((d) => (d.data()['rating'] ?? 0) as num).reduce((a, b) => a + b) / _ratingCount;
      }
      _userRating = userRating;
    });
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    await FirebaseFirestore.instance.collection('blogs').doc(widget.blogId).collection('comments').add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _commentController.clear();
    _loadCommentsAndRatings();
  }

  Future<void> _rateBlog(double rating) async {
    // Only allow integer rating, and only one rating per user
    final user = FirebaseFirestore.instance.app.options.projectId;
    final ratingsRef = FirebaseFirestore.instance.collection('blogs').doc(widget.blogId).collection('ratings');
    final prev = await ratingsRef.where('userId', isEqualTo: user).get();
    if (prev.docs.isNotEmpty) {
      await ratingsRef.doc(prev.docs.first.id).update({
        'rating': rating.toInt(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      await ratingsRef.add({
        'userId': user,
        'rating': rating.toInt(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    setState(() { _userRating = rating.toInt(); });
    _loadCommentsAndRatings();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Blog Details', style: TextStyle(color: Colors.white)),
      ),
      body: _loading || _blog == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_blog!['title'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Author: ${_blog!['authorName'] ?? 'Unknown'}', style: const TextStyle(color: AppColors.veryLightBlue, fontSize: 16)),
                    const SizedBox(height: 16),
                    Text(_blog!['description'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 24),
                    Divider(color: AppColors.veryLightBlue, thickness: 1),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Average Rating: ', style: TextStyle(color: Colors.white)),
                        Text(_avgRating.toStringAsFixed(1), style: const TextStyle(color: AppColors.paleBlue, fontWeight: FontWeight.bold)),
                        Text(' ($_ratingCount)', style: const TextStyle(color: AppColors.veryLightBlue)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_userRating == null)
                      Row(
                        children: List.generate(5, (i) => IconButton(
                          icon: Icon(Icons.star, color: i < 0 ? Colors.amber : Colors.grey),
                          onPressed: () => _rateBlog(i + 1),
                        )),
                      )
                    else
                      Row(
                        children: [
                          const Text('Your Rating: ', style: TextStyle(color: Colors.white)),
                          ...List.generate(5, (i) => Icon(Icons.star, color: i < (_userRating ?? 0) ? Colors.amber : Colors.grey)),
                        ],
                      ),
                    const SizedBox(height: 16),
                    Divider(color: AppColors.veryLightBlue, thickness: 1),
                    const SizedBox(height: 8),
                    const Text('Comments', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    ..._comments.map((c) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.veryLightBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(c['text'] ?? '', style: const TextStyle(color: Colors.white)),
                    )),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              hintStyle: const TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: AppColors.blue,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _addComment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Send'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      );
    }
  }

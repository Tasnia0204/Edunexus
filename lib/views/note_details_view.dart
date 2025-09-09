import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteDetailsView extends StatefulWidget {
  final String noteId;
  const NoteDetailsView({super.key, required this.noteId});

  @override
  State<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  final _commentController = TextEditingController();
  int? _userRating;
  bool _loading = true;
  Map<String, dynamic>? _note;
  List<Map<String, dynamic>> _comments = [];
  double _avgRating = 0;
  int _ratingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNote();
    _loadCommentsAndRatings();
  }

  Future<void> _loadNote() async {
    final doc = await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).get();
    setState(() {
      _note = doc.data();
      _loading = false;
    });
  }

  Future<void> _loadCommentsAndRatings() async {
    final commentsSnap = await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).collection('comments').orderBy('timestamp').get();
    final ratingsSnap = await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).collection('ratings').get();
    final user = await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).collection('ratings')
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
    await FirebaseFirestore.instance.collection('notes').doc(widget.noteId).collection('comments').add({
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _commentController.clear();
    _loadCommentsAndRatings();
  }

  Future<void> _rateNote(double rating) async {
    // Only allow integer rating, and only one rating per user
    final user = FirebaseFirestore.instance.app.options.projectId;
    final ratingsRef = FirebaseFirestore.instance.collection('notes').doc(widget.noteId).collection('ratings');
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
        title: const Text('Note Details', style: TextStyle(color: Colors.white)),
      ),
      body: _loading || _note == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_note!['noteName'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Course: ${_note!['courseName'] ?? ''}', style: const TextStyle(color: AppColors.veryLightBlue, fontSize: 16)),
                    Text('Faculty: ${_note!['facultyName'] ?? ''}', style: const TextStyle(color: AppColors.veryLightBlue, fontSize: 16)),
                    Text('Author: ${_note!['authorName'] ?? 'Unknown'}', style: const TextStyle(color: AppColors.veryLightBlue, fontSize: 16)),
                    const SizedBox(height: 16),
                    if ((_note!['driveLink'] ?? '').isNotEmpty)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blue,
                          foregroundColor: AppColors.darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.link),
                        label: const Text('Open Google Drive Link', style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final url = Uri.parse(_note!['driveLink']);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                    const SizedBox(height: 16),
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
                          onPressed: () => _rateNote(i + 1),
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
                              hintStyle: const TextStyle(color: AppColors.veryLightBlue),
                              filled: true,
                              fillColor: AppColors.veryLightBlue.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: AppColors.blue),
                          onPressed: _addComment,
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
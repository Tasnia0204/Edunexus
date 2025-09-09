import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_colors.dart';
import 'note_details_view.dart';
import '../controllers/note_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  final NoteController _noteController = NoteController();
  @override
  Widget build(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
  final userId = user?.uid ?? '';
  return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notes', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _noteController.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notes found', style: TextStyle(color: Colors.white)));
          }
          final notes = snapshot.data!.docs
              .where((doc) => (doc['authorId'] ?? '') != userId)
              .toList();
          if (notes.isEmpty) {
            return const Center(child: Text('No notes found', style: TextStyle(color: Colors.white)));
          }
          return ListView.separated(
            itemCount: notes.length,
            separatorBuilder: (_, __) => const Divider(color: AppColors.paleBlue),
            itemBuilder: (context, i) {
              final note = notes[i].data() as Map<String, dynamic>;
              return FutureBuilder<QuerySnapshot>(
                future: _noteController.getNoteRatings(notes[i].id),
                builder: (context, ratingSnap) {
                  double avgRating = 0;
                  int ratingCount = 0;
                  if (ratingSnap.hasData && ratingSnap.data!.docs.isNotEmpty) {
                    ratingCount = ratingSnap.data!.docs.length;
                    avgRating = ratingSnap.data!.docs.map((d) => (d['rating'] ?? 0) as num).reduce((a, b) => a + b) / ratingCount;
                  }
                  return ListTile(
                    title: Text(note['noteName'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${note['courseName'] ?? ''} - ${note['facultyName'] ?? ''}', style: const TextStyle(color: AppColors.veryLightBlue)),
                        Text('Author: ${note['authorName'] ?? 'Unknown'}', style: const TextStyle(color: AppColors.veryLightBlue, fontSize: 13)),
                        Row(
                          children: [
                            const Text('Avg Rating: ', style: TextStyle(color: Colors.white, fontSize: 12)),
                            Text(avgRating.toStringAsFixed(1), style: const TextStyle(color: AppColors.paleBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(' ($ratingCount)', style: const TextStyle(color: AppColors.veryLightBlue, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailsView(noteId: notes[i].id),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

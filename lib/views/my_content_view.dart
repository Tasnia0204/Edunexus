import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_colors.dart';
import 'upload_note_view.dart';
import 'create_blog_view.dart';

class MyContentView extends StatefulWidget {
  const MyContentView({super.key});

  @override
  State<MyContentView> createState() => _MyContentViewState();
}

class _MyContentViewState extends State<MyContentView> {
  int _selectedTab = 0; // 0 = Notes, 1 = Blogs

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
        title: const Text('My Content', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TabButton(
                label: 'Notes',
                selected: _selectedTab == 0,
                onTap: () => setState(() => _selectedTab = 0),
              ),
              const SizedBox(width: 16),
              _TabButton(
                label: 'Blogs',
                selected: _selectedTab == 1,
                onTap: () => setState(() => _selectedTab = 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedTab == 0)
            Expanded(
              child: _MyNotesSection(),
            ),
          if (_selectedTab == 1)
            Expanded(
              child: _MyBlogsSection(),
            ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? AppColors.blue : AppColors.veryLightBlue,
        foregroundColor: selected ? Colors.white : AppColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      ),
      onPressed: onTap,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }
}

class _MyNotesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('notes').where('authorId', isEqualTo: userId).orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No notes found', style: TextStyle(color: Colors.white)));
              }
              // Only show notes with authorId == userId (handle missing field)
              final notes = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['authorId'] == userId;
              }).toList();
              if (notes.isEmpty) {
                return const Center(child: Text('No notes found', style: TextStyle(color: Colors.white)));
              }
              return ListView.separated(
                itemCount: notes.length,
                separatorBuilder: (_, __) => const Divider(color: AppColors.paleBlue),
                itemBuilder: (context, i) {
                  final note = notes[i].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(note['noteName'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${note['courseName'] ?? ''} - ${note['facultyName'] ?? ''}',
                      style: const TextStyle(color: AppColors.veryLightBlue),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UploadNoteView()),
              );
            },
            child: const Text('Upload Note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

class _MyBlogsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('blogs').where('authorId', isEqualTo: userId).orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No blogs found', style: TextStyle(color: Colors.white)));
              }
              // Only show blogs with authorId == userId (handle missing field)
              final blogs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return data['authorId'] == userId;
              }).toList();
              if (blogs.isEmpty) {
                return const Center(child: Text('No blogs found', style: TextStyle(color: Colors.white)));
              }
              return ListView.separated(
                itemCount: blogs.length,
                separatorBuilder: (_, __) => const Divider(color: AppColors.paleBlue),
                itemBuilder: (context, i) {
                  final blog = blogs[i].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(blog['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      blog['description'] ?? '',
                      style: const TextStyle(color: AppColors.veryLightBlue),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: AppColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateBlogView()),
              );
            },
            child: const Text('Create Blog', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

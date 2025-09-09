import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/blog_controller.dart';
import '../models/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'blog_details_view.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({super.key});

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView> {
  final BlogController _blogController = BlogController();

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
        title: const Text('Blogs', style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _blogController.getBlogsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No blogs found', style: TextStyle(color: Colors.white)));
          }
          final blogs = snapshot.data!.docs
              .where((doc) => (doc['authorId'] ?? '') != userId)
              .toList();
          if (blogs.isEmpty) {
            return const Center(child: Text('No blogs found', style: TextStyle(color: Colors.white)));
          }
          return ListView.separated(
            itemCount: blogs.length,
            separatorBuilder: (_, __) => const Divider(color: AppColors.paleBlue),
            itemBuilder: (context, i) {
              final blog = blogs[i].data() as Map<String, dynamic>;
              return FutureBuilder<QuerySnapshot>(
                future: _blogController.getBlogRatings(blogs[i].id),
                builder: (context, ratingSnap) {
                  double avgRating = 0;
                  int ratingCount = 0;
                  if (ratingSnap.hasData && ratingSnap.data!.docs.isNotEmpty) {
                    ratingCount = ratingSnap.data!.docs.length;
                    avgRating = ratingSnap.data!.docs.map((d) => (d['rating'] ?? 0) as num).reduce((a, b) => a + b) / ratingCount;
                  }
                  return ListTile(
                    title: Text(blog['title'] ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(blog['description'] ?? '', style: const TextStyle(color: AppColors.veryLightBlue), maxLines: 2, overflow: TextOverflow.ellipsis),
                        Text('Author: ${blog['authorName'] ?? 'Unknown'}', style: const TextStyle(color: AppColors.veryLightBlue, fontSize: 13)),
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
                          builder: (context) => BlogDetailsView(blogId: blogs[i].id),
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

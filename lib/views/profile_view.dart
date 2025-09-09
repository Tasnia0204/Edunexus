import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';
import '../models/app_colors.dart';
import 'edit_profile_view.dart';
import 'search_view.dart';
import 'note_list_view.dart';
import 'blog_list_view.dart';
import 'my_content_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController _controller = ProfileController();
  Map<String, dynamic>? _userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _controller.getUserProfile();
    setState(() {
      _userData = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileView(
                  onProfileUpdated: () {
                    _loadProfile();
                    Navigator.pop(context);
                  },
                  onBack: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchView(
                    onBack: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('No user data found', style: TextStyle(color: Colors.white)))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundImage: const AssetImage('assets/demo_profile.png'),
                                backgroundColor: AppColors.veryLightBlue,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _userData!["name"] ?? "User Name",
                                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _userData!["department"] ?? "Department",
                                    style: const TextStyle(color: AppColors.veryLightBlue, fontSize: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '(${_userData!["admittedYear"] ?? "Year"})',
                                    style: const TextStyle(color: AppColors.veryLightBlue, fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _userData!["bio"] ?? "No bio set.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppColors.paleBlue, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _ProfileButton(
                              label: 'Notes',
                              icon: Icons.note,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NoteListView(),
                                  ),
                                );
                              },
                            ),
                            _ProfileButton(
                              label: 'Blogs',
                              icon: Icons.videocam,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BlogListView(),
                                  ),
                                );
                              },
                            ),
                            _ProfileButton(
                              label: 'Group',
                              icon: Icons.group,
                              onTap: () {
                                // TODO: Implement Group navigation
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
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
                                MaterialPageRoute(
                                  builder: (context) => const MyContentView(),
                                ),
                              );
                            },
                            child: const Text('My Content', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.blue,
                              foregroundColor: AppColors.darkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () async {
                              await _controller.logOut();
                              // TODO: Implement logout navigation
                            },
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ProfileButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.veryLightBlue,
        foregroundColor: AppColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.blue),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.blue)),
    );
  }
}

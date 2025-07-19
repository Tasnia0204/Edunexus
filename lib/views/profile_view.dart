
import 'package:flutter/material.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = ProfileController();
    controller.addListener(_update);
  }

  @override
  void dispose() {
    controller.removeListener(_update);
    controller.dispose();
    super.dispose();
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Color(0xFF081F5C)),
          onPressed: () => controller.logout(context),
          tooltip: 'Log Out',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF334EAC)),
            onPressed: () {},
            tooltip: 'Search',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF334EAC), width: 3),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/300?img=5',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Name:',
                    style: TextStyle(fontSize: 16, color: Color(0xFF334EAC), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tasnia Jahan',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF081F5C)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Email:',
                    style: TextStyle(fontSize: 16, color: Color(0xFF334EAC), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'tasnia0204@gmail.com',
                    style: TextStyle(fontSize: 18, color: Color(0xFF081F5C)),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Password:',
                    style: TextStyle(fontSize: 16, color: Color(0xFF334EAC), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF334EAC)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          controller.obscurePassword ? '*********' : 'hello1234',
                          style: const TextStyle(fontSize: 18, color: Color(0xFF081F5C)),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: controller.togglePasswordVisibility,
                          child: Icon(
                            controller.obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFF334EAC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
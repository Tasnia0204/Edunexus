import 'package:flutter/material.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF081F5C)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            // Larger image in the first half
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset('assets/me.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tasnia Jahan',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF081F5C),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF334EAC)),
              ),
              child: const Text(
                'I am Tasnia Jahan, a passionate Flutter developer. I love building beautiful and functional mobile applications. Welcome to EduNexus!',
                style: TextStyle(fontSize: 16, color: Color(0xFF081F5C)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF9FCFF),
    );
  }
}
